# Document Formatting Defaults

These are the user's preferred formatting defaults for all generated documents. The destination is **Notion**, which imports clean Markdown well. Don't generate HTML, font/size hints, or page-margin styling — Notion controls all of that.

## Output Format

- Write plain Markdown. Notion handles styling on import.
- No HTML wrappers, no inline CSS, no `<style>` blocks, no `@page` rules.
- No font, size, color, or margin directives. Notion uses its own theme.

## Headings

- Notion supports H1, H2, H3 only. H4+ in Markdown is converted to bold text on import, which breaks navigation and the table of contents — don't use `####` or deeper.
- The first `# Heading` in the file becomes the page title in Notion. There should be exactly one H1 per file, at the top.
- Body sections should start at `##`. Subsections use `###`. If you need a fourth level, restructure the content instead.
- Use bold (`**Label**`) for emphasis within a section, not as a stand-in for a heading.

## Tables

- Use standard Markdown table syntax. Notion imports these as "simple tables."
- Keep column counts reasonable (typically ≤5). Very wide tables are hard to read in Notion's page layout.
- Don't add blank lines inside table blocks. One blank line before and after the table is enough.
- Don't try to color cells or rows — Notion's simple tables don't support cell styling on import.

## Dashes

- Never use em dashes, en dashes, or hyphens as sentence connectors or parenthetical separators.
- Rewrite the sentence instead: use periods, semicolons, colons, commas, or parentheses.
- Only use hyphens where a normal person would (e.g., compound words like "top-of-funnel", phone numbers, date ranges with "to").

## Dividers

- `---` on its own line works in Notion as a divider block. Use sparingly — heading hierarchy usually does the job better.

## Callouts and quotes

- Markdown blockquotes (`> ...`) import as Notion quote blocks. Use them for emphasis or pulled quotes.
- Notion's callout block (the colored box with an icon) doesn't have a standard Markdown equivalent. If a callout is desired, write a blockquote and the user can convert it to a callout in Notion.

## Code

- Use fenced code blocks with language tags (```` ```python ````). Notion preserves the language and syntax highlighting.

## Lists

- Standard Markdown bullets (`-`) and numbered lists work as expected.
- Indent nested items with two spaces.
- Don't mix `-` and `*` bullet markers in the same file.

## Links

- Use inline Markdown links: `[label](url)`. Notion converts these to clickable links.
- Avoid bare URLs in body text; wrap them in a link with a meaningful label.
