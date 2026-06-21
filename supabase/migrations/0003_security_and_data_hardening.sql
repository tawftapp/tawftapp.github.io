-- Bring older deployed schemas forward safely.
DO $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'widgets'
      AND column_name = 'preview_asset'
  ) AND NOT EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = 'public'
      AND table_name = 'widgets'
      AND column_name = 'preview_file'
  ) THEN
    ALTER TABLE public.widgets RENAME COLUMN preview_asset TO preview_file;
  END IF;
END
$$;

-- Canonicalize legacy category values and the known broken asset path.
UPDATE public.widgets SET category = 'Navigation' WHERE category = 'Navigaton';
UPDATE public.widgets SET category = 'Cards' WHERE category = ' Cards';
UPDATE public.widgets SET category = 'Forms & Inputs' WHERE category = 'Forms & Input';
UPDATE public.widgets
SET preview_file = 'interactions/badge.mp4'
WHERE preview_file = 'interactons/badge.mp4';

UPDATE public.categories
SET name = 'Forms & Inputs'
WHERE name = 'Forms & Input'
  AND NOT EXISTS (
    SELECT 1 FROM public.categories WHERE name = 'Forms & Inputs'
  );
DELETE FROM public.categories WHERE name = 'Forms & Input';

INSERT INTO public.categories (name, sort_order)
VALUES
  ('Navigation', 1),
  ('Cards', 2),
  ('Micro Interactions', 3),
  ('Slivers & Scroll Effects', 4),
  ('Buttons', 5),
  ('Forms & Inputs', 6),
  ('Chat & Messaging', 7)
ON CONFLICT (name) DO UPDATE SET sort_order = EXCLUDED.sort_order;

-- Prevent category and preview-path drift from returning.
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'widgets_category_fkey'
      AND conrelid = 'public.widgets'::regclass
  ) THEN
    ALTER TABLE public.widgets
      ADD CONSTRAINT widgets_category_fkey
      FOREIGN KEY (category)
      REFERENCES public.categories(name)
      ON UPDATE CASCADE;
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'widgets_preview_file_safe'
      AND conrelid = 'public.widgets'::regclass
  ) THEN
    ALTER TABLE public.widgets
      ADD CONSTRAINT widgets_preview_file_safe
      CHECK (
        preview_file !~ '\.\.'
        AND preview_file ~ '^[A-Za-z0-9][A-Za-z0-9._/-]*\.(png|jpg|jpeg|webp|gif|mp4|webm)$'
      );
  END IF;
END
$$;

-- Maintain a searchable projection so search remains paginated and includes
-- array tags without downloading the whole table to the browser.
ALTER TABLE public.widgets
  ADD COLUMN IF NOT EXISTS search_text TEXT NOT NULL DEFAULT '';

CREATE OR REPLACE FUNCTION public.set_widget_search_text()
RETURNS trigger
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  NEW.search_text := lower(
    concat_ws(
      ' ',
      NEW.title,
      NEW.description,
      NEW.category,
      NEW.language,
      array_to_string(NEW.tags, ' ')
    )
  );
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS widgets_search_text_trigger ON public.widgets;
CREATE TRIGGER widgets_search_text_trigger
BEFORE INSERT OR UPDATE OF title, description, category, language, tags
ON public.widgets
FOR EACH ROW
EXECUTE FUNCTION public.set_widget_search_text();

REVOKE ALL ON FUNCTION public.set_widget_search_text() FROM PUBLIC;

UPDATE public.widgets
SET search_text = lower(
  concat_ws(
    ' ',
    title,
    description,
    category,
    language,
    array_to_string(tags, ' ')
  )
);

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_widgets_search_text
  ON public.widgets USING gin (search_text gin_trgm_ops);

-- Public clients are read-only. RLS remains the row-level enforcement layer.
REVOKE INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES, TRIGGER
  ON public.widgets, public.categories
  FROM anon, authenticated;
GRANT SELECT ON public.widgets, public.categories TO anon, authenticated;

-- Version the preview bucket rather than relying on dashboard-only state.
INSERT INTO storage.buckets (
  id,
  name,
  public,
  file_size_limit,
  allowed_mime_types
)
VALUES (
  'widgets',
  'widgets',
  true,
  26214400,
  ARRAY[
    'image/png',
    'image/jpeg',
    'image/webp',
    'image/gif',
    'video/mp4',
    'video/webm'
  ]
)
ON CONFLICT (id) DO UPDATE SET
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

DROP POLICY IF EXISTS "Public read access for widget previews"
  ON storage.objects;
CREATE POLICY "Public read access for widget previews"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'widgets');

-- This gallery never accepts browser uploads. Revoke write privileges even if
-- a permissive dashboard-created storage policy exists.
REVOKE INSERT, UPDATE, DELETE ON storage.objects FROM anon, authenticated;
GRANT SELECT ON storage.objects TO anon, authenticated;
