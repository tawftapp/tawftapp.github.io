---
name: There’s A Widget For That
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#bdc8d2'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#87929c'
  outline-variant: '#3e4851'
  surface-tint: '#89ceff'
  primary: '#89ceff'
  on-primary: '#00344d'
  primary-container: '#00b4ff'
  on-primary-container: '#004361'
  inverse-primary: '#006591'
  secondary: '#dcb8ff'
  on-secondary: '#480081'
  secondary-container: '#7701d0'
  on-secondary-container: '#dcb7ff'
  tertiary: '#ffb86a'
  on-tertiary: '#492900'
  tertiary-container: '#f09408'
  on-tertiary-container: '#5b3500'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#c9e6ff'
  primary-fixed-dim: '#89ceff'
  on-primary-fixed: '#001e2f'
  on-primary-fixed-variant: '#004c6e'
  secondary-fixed: '#efdbff'
  secondary-fixed-dim: '#dcb8ff'
  on-secondary-fixed: '#2c0051'
  on-secondary-fixed-variant: '#6700b5'
  tertiary-fixed: '#ffdcbc'
  tertiary-fixed-dim: '#ffb86a'
  on-tertiary-fixed: '#2c1700'
  on-tertiary-fixed-variant: '#683d00'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
typography:
  display-lg:
    fontFamily: Geist
    fontSize: 48px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.04em
  headline-lg:
    fontFamily: Geist
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.02em
  headline-lg-mobile:
    fontFamily: Geist
    fontSize: 24px
    fontWeight: '600'
    lineHeight: '1.2'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
    letterSpacing: -0.01em
  code-sm:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '400'
    lineHeight: '1.5'
  label-caps:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '600'
    lineHeight: '1'
    letterSpacing: 0.1em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  container-max: 1200px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 40px
  stack-sm: 8px
  stack-md: 24px
  stack-lg: 48px
---

## Brand & Style

The design system is engineered for a highly technical audience—developers and designers seeking premium Flutter components. The brand personality is **precise, futuristic, and high-fidelity**, mirroring the "Modern Startup" aesthetic defined by industry leaders like Linear and Vercel.

The visual direction utilizes a **Minimal-Futurism** style. It relies on deep obsidian canvases to create a sense of infinite depth, punctuated by sharp, high-contrast typography and subtle interactive "glows." The interface should feel like a high-end IDE—efficient and utilitarian, yet polished with sophisticated glassmorphism and motion. The goal is to evoke a sense of "engineered beauty" and technical mastery.

## Colors

The palette is strictly dark-moded, centered around **Obsidian (#000000)** for the base background to ensure absolute contrast with foreground elements. 

- **Primary & Secondary:** A digital "Flutter Blue" and "Deep Violet" serve as functional accents and brand identifiers. These are rarely used as solid fills, appearing instead as thin borders, glowing states, or subtle gradients.
- **Neutrals:** We use a tiered charcoal system (#0A0A0A, #111111) to create structural hierarchy without relying on heavy lines.
- **Status:** Success, Warning, and Error colors are desaturated to maintain the minimal aesthetic, only becoming vibrant on hover or active states.

## Typography

Typography focuses on legibility and technical rigor. 

- **Geist** is used for headings and display elements, providing a sharp, geometric look that feels modern and engineered.
- **Inter** handles the bulk of the body text, chosen for its exceptional readability in dense developer documentation.
- **JetBrains Mono** is reserved for code snippets, widget parameters, and technical metadata, reinforcing the platform's developer-centric nature.

Hierarchy is established primarily through scale and weight rather than color. All headings should use tighter letter-spacing to achieve the "startup" look.

## Layout & Spacing

The layout philosophy follows a **Fixed-Fluid Hybrid** model. Content is contained within a 1200px max-width grid on desktop to maintain focus, while margins expand fluidly.

- **Grid:** Use a 12-column system for desktop, 8-column for tablet, and 4-column for mobile.
- **Rhythm:** An 8px linear scale (using a 4px base unit) governs all padding and margins. 
- **White Space:** Space is treated as a first-class citizen. Components are given generous breathing room to avoid visual clutter, ensuring that the complex widget previews remain the center of attention.
- **Safe Areas:** On mobile, prioritize bottom-aligned navigation to facilitate one-handed widget browsing.

## Elevation & Depth

Elevation in the design system is achieved through **luminance and translucency** rather than traditional drop shadows.

1.  **Tonal Stacking:** Higher elevation levels use lighter shades of charcoal (e.g., Background #000000 -> Card #0A0A0A -> Modal #111111).
2.  **Glassmorphism:** Overlays and floating panels utilize a backdrop blur (20px-32px) with a semi-transparent fill (`rgba(255, 255, 255, 0.03)`).
3.  **Glow Borders:** Interactive elements use a 1px solid border with low opacity. Active or hovered states may trigger a "backlight" effect—a subtle, colored outer glow using the primary Blue or Violet, with a blur radius of 15px and 0.2 opacity.
4.  **Shadows:** When used, shadows are extremely diffused (`spread: 0, blur: 40px, color: rgba(0,0,0,0.5)`).

## Shapes

The design system utilizes a **Soft (0.25rem)** rounding philosophy. This provides a professional, "tool-like" feel that is more sophisticated than fully rounded "consumer" apps.

- **Small Components (Buttons, Inputs):** 4px (0.25rem) radius.
- **Cards & Containers:** 8px (0.5rem) radius.
- **Large Sections/Modals:** 12px (0.75rem) radius.

Internal elements (like nested code blocks) should have a slightly smaller radius than their parent container to maintain visual nesting harmony.

## Components

### Buttons
- **Primary:** Gradient fill (Blue to Violet), white text, no border. On hover, increase brightness or add a subtle outer glow.
- **Secondary:** Transparent background, 1px white-alpha border (0.1), white text.
- **Ghost:** No border or fill. Accent color text.

### Cards
- Use Obsidian (#0A0A0A) background with a 1px `border_subtle`. 
- For "Featured" widgets, use an **Animated Border**—a gradient stroke that slowly rotates around the perimeter.

### Input Fields
- Dark background (#050505) with 1px border. 
- Focus state: Border color changes to Primary Blue with a 2px outer glow.
- Labels use `label-caps` typography style, positioned above the field.

### Widget Previews
- Interactive containers featuring a "Glass" surface. 
- Must include a "Copy Code" button that appears on hover.
- Use a monochromatic icon set with a consistent 1.5pt stroke weight.

### Chips/Tags
- Small, low-contrast pills (`rounded-full`) with `code-sm` font. 
- Background: `rgba(255, 255, 255, 0.05)`. Text: Grey-400.