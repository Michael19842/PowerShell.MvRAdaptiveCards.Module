---
Module Name: MvRAdaptiveCards
Module Guid: 55db3db7-b8a1-4d0e-ade3-b10d047518ef
Download Help Link: {{ Update Download Link }}
Help Version: {{ Please enter version of help manually (X.X.X.X) format }}
Locale: en-US
---

# MvRAdaptiveCards Module
## Description
The MvRAdaptiveCards module provides PowerShell functions for creating, manipulating, and deploying Microsoft Adaptive Cards. Adaptive Cards are platform-agnostic snippets of UI that can be used in various applications like Microsoft Teams, Outlook, and other supported platforms.

This module offers a comprehensive set of functions for building interactive cards with elements like text blocks, images, tables, containers, and action sets. It also includes advanced templating capabilities for creating reusable card templates with dynamic content replacement, and integration with the online Adaptive Cards Designer for visual testing and development.

## MvRAdaptiveCards Cmdlets

### 🏗️ Core Card Creation
The foundation for building Adaptive Cards and managing the overall card structure.

#### [New-AdaptiveCard](New-AdaptiveCard.md)
Creates a new Adaptive Card with the specified content and configuration options. The main function for building Adaptive Cards with support for Teams-specific formatting, schema validation, and flexible output formats.

### 📦 Container Elements
Functions for organizing and grouping content within your Adaptive Cards.

#### [New-CardContainer](New-CardContainer.md)
Creates a new Container element for grouping multiple card elements together. Provides styling options and layout properties for organizing and visually separating different sections of an Adaptive Card.

#### [New-CardTable](New-CardTable.md)
Creates a new Table element from a collection of objects or hashtables. Automatically generates columns and rows with support for custom column definitions, header control, and dynamic content including ScriptBlocks.

#### [New-CardFactSet](New-CardFactSet.md)
Creates a new FactSet element for displaying key-value pairs in a structured format. Supports input from hashtables or PowerShell objects, automatically converting properties to facts for display.

### 📝 Content Elements
Functions for adding various types of content and media to your cards.

#### [New-CardTextBlock](New-CardTextBlock.md)
Creates a new TextBlock element for displaying text content in an Adaptive Card. Supports various formatting options including size, weight, color, and text wrapping for flexible text presentation.

#### [New-CardImage](New-CardImage.md)
Creates a new Image element for displaying images in an Adaptive Card. Supports various sizing options, fit modes, and accessibility features to ensure proper image display across different devices and platforms.

#### [New-CardCodeBlock](New-CardCodeBlock.md)
Creates a new CodeBlock element for displaying formatted code snippets with syntax highlighting. Supports multiple programming languages and provides options for text wrapping and fallback content.

### ⚡ Interactive Actions
Functions for adding interactivity and user engagement to your cards.

#### [New-CardActionSet](New-CardActionSet.md)
Creates a new ActionSet element for grouping multiple actions together. Allows placement of interactive actions anywhere within a card's body, with support for fallback content on unsupported clients.

#### [New-CardActionShowCard](New-CardActionShowCard.md)
Creates an Action.ShowCard element that reveals an inline card when clicked. Enables progressive disclosure by allowing users to access detailed information without leaving the current card context.

#### [New-CardActionToggleVisibility](New-CardActionToggleVisibility.md)
Creates an Action.ToggleVisibility element that shows or hides targeted card elements. Enables interactive cards where users can toggle visibility of sections, details, or supplementary information.

### 🎨 Template System
Advanced templating functions for creating reusable and dynamic card templates.

#### [New-CardTemplateTag](New-CardTemplateTag.md)
Creates a template tag placeholder that can be replaced with dynamic content in Adaptive Cards. Generates placeholder strings for building reusable card templates with replaceable elements.

#### [Find-CardTemplateTags](Find-CardTemplateTags.md)
Discovers all template tags within an Adaptive Card content structure. Analyzes card templates and identifies all replaceable placeholders for template validation and debugging purposes.

Builds a complete Adaptive Card by replacing template tags with actual content. Supports both simple string replacements and complex ScriptBlock-based dynamic content generation for creating reusable card templates.

### 🚀 Development & Testing
Tools for testing, debugging, and visualizing your Adaptive Cards during development.

#### [Out-OnlineDesigner](Out-OnlineDesigner.md)
Opens an Adaptive Card in the online Adaptive Cards Designer for visualization and testing. Provides a visual preview and allows interactive testing of card functionality in a web browser.

