# Document Formatting Defaults

These are the user's preferred formatting defaults for all generated documents (HTML for Google Docs import, etc.).

## Font
- **Family:** Arial
- **Sizes:** Title: 26pt, H1: 20pt, H2: 16pt, H3: 14pt, H4: 12pt, Normal text: 11pt
- **Colors:** Normal text: #000000, Text on black backgrounds (e.g., table header row): #ffffff

## Font Styles
- Title and all headings: **always bold**
- Normal text: no bold, no italics, no underlines

## Margins
- Left and right margins: 1 inch
- In HTML: use `@page { margin: 1in; }` for margins. Never use body padding or margin for page margins, as it stacks on top of Google Docs' own margins when imported.

## Heading Spacing
- Keep spacing tight between headings, horizontal rules, and content.
- In HTML: heading margin-bottom should be 2pt. Heading margin-top: Title 0, H1 12pt, H2 10pt, H3 8pt, H4 6pt.

## Body Text
- Line spacing: 1.15
- No space before paragraphs
- Add space after paragraphs (margin-bottom: 6pt in HTML)

## Tables
- Style: inline
- Alignment: left
- Column data type: none
- Cell vertical alignment: top
- Cell padding: 0.069 inch (~5px)
- Table border: #000000, 1pt
- Cell background: none (transparent/white)
- Header row: background #000000, font color #ffffff
- No alternating row colors

## Dashes
- Never use em dashes, en dashes, or hyphens as sentence connectors or parenthetical separators.
- Rewrite the sentence instead: use periods, semicolons, colons, commas, or parentheses.
- Only use hyphens where a normal person would (e.g., compound words like "top-of-funnel", phone numbers, date ranges with "to").

## Horizontal Rules
- Never use horizontal rules (`<hr>`) in documents. They cause formatting issues in Google Docs imports.
- Use heading hierarchy alone to create visual separation between sections.
