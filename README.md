# Heytag PII Flow (Web)

**Heytag PII Flow** is a GTM Variable Template designed to bridge the gap between raw user input and high-precision tracking. It ensures your data is perfectly formatted and securely hashed before leaving the browser.

This template is developed and maintained by [Heytag](https://heytag.de), a European server-side tagging provider based in Germany. Heytag empowers businesses to take full control of tracking data, improve website performance, and ensure GDPR compliance through high-performance, locally hosted infrastructure.

Explore how to unite privacy and performance at [heytag.de](https://heytag.de).

## Key Benefits
### Enhanced Match Rates
Data quality is the bottleneck of modern tracking. Inconsistent inputs like spaces, brackets, or missing country codes lead to poor attribution. This template enforces strict formatting for Meta CAPI and Google Enhanced Conversions, ensuring your marketing signals actually reach their destination and improve your ROAS.

### Privacy-First Security
Security is a core pillar of the Heytag ecosystem. By using industry-standard SHA-256 hashing, this template ensures that personally identifiable information (PII) is never transmitted in plain text. This keeps your setup compliant with global privacy standards while maintaining full tracking capabilities.

### Hybrid Tagging Readiness
Built for the modern tracking stack, this template offers a seamless transition between client-side and server-side tagging. You can choose to hash data instantly in the browser or pass cleaned plain-text strings directly to your server-side tagging environment. This provides maximum flexibility for advanced server-side processing, helping you offload heavy logic from the user's browser to a secure, controlled infrastructure.

## How it works
- Input: Messy user data from a form or dataLayer.
- Clean: Removal of all noise (spaces, dashes, brackets).
- Fix: Application of `E.164` formatting for phone numbers.
- Secure: Optional one-way `SHA-256` hashing.
- Output: A "ready-to-fire" signal for your marketing tags.

## Configuration

### Fields
- **Input String**: The variable containing the raw user data (e.g., `{{DLV - Email}}`).
- **Trim Whitespace**: Removes leading/trailing spaces.
- **Convert to Lowercase**: Recommended for Email hashing.
- **Is Phone Number**: Enables specialized E.164 formatting logic.
- **Default Country Code**: The prefix used if a phone number starts with a single `0` (default: `49`).
- **Enable Hashing**: When checked, outputs a SHA-256 hex string. When unchecked, outputs the normalized plain text.

## Installation

1. Download the `template.tpl` file.
2. In GTM, go to **Templates** > **Variable Templates** > **New**.
3. Click the three dots (top right) > **Import**.
4. Select the file and **Save**.

## Testing
The template includes a comprehensive test suite covering:
- Full normalization of messy email strings.
- Conversion of various phone formats (local, 00-prefix, bracketed).
- Hash verification against official SHA-256 standards.

## License
[MIT](LICENSE)