-- Create the widgets table
CREATE TABLE public.widgets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    category TEXT NOT NULL,
    tags TEXT[] NOT NULL DEFAULT '{}',
    language TEXT NOT NULL,
    raw_code TEXT NOT NULL,
    preview_asset TEXT NOT NULL,
    featured BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Set up Row Level Security (RLS)
ALTER TABLE public.widgets ENABLE ROW LEVEL SECURITY;

-- Create policy to allow public read access
CREATE POLICY "Allow public read access on widgets" 
ON public.widgets FOR SELECT 
USING (true);

-- Index for cursor-based pagination
CREATE INDEX idx_widgets_created_at_id ON public.widgets (created_at DESC, id DESC);
