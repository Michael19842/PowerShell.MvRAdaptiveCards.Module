(function () {
    const AC = AdaptiveCards;

    // Load Prism.js for syntax highlighting
    (function loadPrism() {
        if (typeof window.Prism !== 'undefined') {
            return; // Already loaded
        }

        // Load Prism CSS
        const prismCss = document.createElement('link');
        prismCss.rel = 'stylesheet';
        prismCss.href = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism.min.css';
        document.head.appendChild(prismCss);

        // Load Prism JS
        const prismJs = document.createElement('script');
        prismJs.src = 'https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js';
        prismJs.setAttribute('data-manual', '');
        document.head.appendChild(prismJs);

        // Load language components
        const languages = [
            'powershell',
            'javascript',
            'typescript',
            'python',
            'json',
            'xml-doc',
            'markup',
            'css',
            'sql',
            'bash'
        ];

        languages.forEach(lang => {
            const script = document.createElement('script');
            script.src = `https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/components/prism-${lang}.min.js`;
            document.head.appendChild(script);
        });
    })();

    // CodeBlock element
    class CodeBlock extends AC.CardElement {
        constructor() {
            super();
            this.code = '';
            this.language = 'plaintext';
            this.lineNumbers = false;
            this.highlightLines = [];
            this.caption = '';
            this.wrap = false;
        }

        getJsonTypeName() {
            return "CodeBlock";
        }

        parse(source, context) {
            super.parse(source, context);

            // Accept both 'code' and 'codeSnippet' properties
            if (source.code !== undefined) {
                this.code = source.code;
            } else if (source.codeSnippet !== undefined) {
                this.code = source.codeSnippet;
            }

            if (source.language !== undefined) {
                this.language = source.language;
            }
            if (source.lineNumbers !== undefined) {
                this.lineNumbers = source.lineNumbers;
            }
            if (source.highlightLines !== undefined) {
                this.highlightLines = source.highlightLines;
            }
            if (source.caption !== undefined) {
                this.caption = source.caption;
            }
            if (source.wrap !== undefined) {
                this.wrap = source.wrap;
            }
        }

        internalRender() {
            const container = document.createElement('div');
            container.className = 'ac-codeblock-container';

            // Add caption if provided
            if (this.caption) {
                const captionElement = document.createElement('div');
                captionElement.className = 'ac-codeblock-caption';
                captionElement.textContent = this.caption;
                container.appendChild(captionElement);
            }

            // Create code wrapper
            const codeWrapper = document.createElement('div');
            codeWrapper.className = 'ac-codeblock-wrapper';
            if (this.wrap) {
                codeWrapper.classList.add('ac-codeblock-wrap');
            }

            // Create pre element
            const preElement = document.createElement('pre');
            preElement.className = 'ac-codeblock-pre';

            // Create code element
            const codeElement = document.createElement('code');
            codeElement.className = `ac-codeblock-code language-${this.language}`;

            // Split code into lines if line numbers or highlighting is needed
            if (this.lineNumbers || this.highlightLines.length > 0) {
                const lines = this.code.split('\n');
                const lineContainer = document.createElement('div');
                lineContainer.className = 'ac-codeblock-lines';

                lines.forEach((line, index) => {
                    const lineNumber = index + 1;
                    const lineElement = document.createElement('div');
                    lineElement.className = 'ac-codeblock-line';

                    if (this.highlightLines.includes(lineNumber)) {
                        lineElement.classList.add('ac-codeblock-line-highlighted');
                    }

                    if (this.lineNumbers) {
                        const lineNumElement = document.createElement('span');
                        lineNumElement.className = 'ac-codeblock-line-number';
                        lineNumElement.textContent = lineNumber;
                        lineElement.appendChild(lineNumElement);
                    }

                    const lineContentElement = document.createElement('span');
                    lineContentElement.className = 'ac-codeblock-line-content';
                    lineContentElement.textContent = line || ' ';

                    lineElement.appendChild(lineContentElement);

                    lineContainer.appendChild(lineElement);
                });

                codeElement.appendChild(lineContainer);

                // Apply highlighting to all lines after rendering
                setTimeout(() => {
                    this.highlightLines(lineContainer, this.language);
                }, 100);
            } else {
                // Simple code block without line numbers - apply syntax highlighting
                codeElement.textContent = this.code;

                // Try to apply Prism syntax highlighting
                this.applyHighlighting(codeElement, this.code, this.language);
            }

            preElement.appendChild(codeElement);

            // Add copy button
            const copyButton = document.createElement('button');
            copyButton.className = 'ac-codeblock-copy-button';
            copyButton.setAttribute('aria-label', 'Copy code to clipboard');
            copyButton.setAttribute('title', 'Copy code');
            copyButton.innerHTML = '<span class="ac-codeblock-copy-icon">📋</span>';

            copyButton.addEventListener('click', () => {
                this.copyToClipboard(copyButton);
            });

            // Add elements to wrapper (removed language badge)
            codeWrapper.appendChild(copyButton);
            codeWrapper.appendChild(preElement);
            container.appendChild(codeWrapper);

            return container;
        }

        applyHighlighting(codeElement, code, language, retries = 0) {
            if (typeof window.Prism !== 'undefined' && window.Prism.languages) {
                const lang = this.getPrismLanguage(language);
                if (window.Prism.languages[lang]) {
                    try {
                        const highlighted = window.Prism.highlight(code, window.Prism.languages[lang], lang);
                        codeElement.innerHTML = highlighted;
                        return;
                    } catch (e) {
                        console.warn('Prism highlighting failed:', e);
                    }
                }
            }

            // Retry up to 5 times with 200ms delay
            if (retries < 5) {
                setTimeout(() => {
                    this.applyHighlighting(codeElement, code, language, retries + 1);
                }, 200);
            }
        }

        highlightLines(lineContainer, language) {
            if (typeof window.Prism === 'undefined' || !window.Prism.languages) {
                // Retry after delay
                setTimeout(() => {
                    this.highlightLines(lineContainer, language);
                }, 200);
                return;
            }

            const lang = this.getPrismLanguage(language);
            if (!window.Prism.languages[lang]) {
                return;
            }

            const lineContentElements = lineContainer.querySelectorAll('.ac-codeblock-line-content');
            lineContentElements.forEach(lineElement => {
                const text = lineElement.textContent;
                try {
                    const highlighted = window.Prism.highlight(text, window.Prism.languages[lang], lang);
                    lineElement.innerHTML = highlighted;
                } catch (e) {
                    console.warn('Prism highlighting failed for line:', e);
                }
            });
        }

        getPrismLanguage(language) {
            // Map language names to Prism language identifiers
            const languageMap = {
                'powershell': 'powershell',
                'pwsh': 'powershell',
                'javascript': 'javascript',
                'js': 'javascript',
                'typescript': 'typescript',
                'ts': 'typescript',
                'python': 'python',
                'py': 'python',
                'json': 'json',
                'xml': 'xml',
                'html': 'markup',
                'css': 'css',
                'sql': 'sql',
                'bash': 'bash',
                'shell': 'bash',
                'sh': 'bash',
                'csharp': 'csharp',
                'cs': 'csharp',
                'cpp': 'cpp',
                'c++': 'cpp',
                'java': 'java',
                'php': 'php',
                'ruby': 'ruby',
                'go': 'go',
                'rust': 'rust',
                'swift': 'swift',
                'kotlin': 'kotlin',
                'yaml': 'yaml',
                'markdown': 'markdown',
                'md': 'markdown'
            };

            return languageMap[language.toLowerCase()] || 'plaintext';
        }

        copyToClipboard(button) {
            const textToCopy = this.code;

            if (navigator.clipboard && navigator.clipboard.writeText) {
                navigator.clipboard.writeText(textToCopy)
                    .then(() => {
                        this.showCopyFeedback(button, true);
                    })
                    .catch(err => {
                        console.error('Failed to copy:', err);
                        this.showCopyFeedback(button, false);
                    });
            } else {
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = textToCopy;
                textArea.style.position = 'fixed';
                textArea.style.left = '-999999px';
                document.body.appendChild(textArea);
                textArea.select();

                try {
                    const successful = document.execCommand('copy');
                    this.showCopyFeedback(button, successful);
                } catch (err) {
                    console.error('Failed to copy:', err);
                    this.showCopyFeedback(button, false);
                }

                document.body.removeChild(textArea);
            }
        }

        showCopyFeedback(button, success) {
            const icon = button.querySelector('.ac-codeblock-copy-icon');
            const originalIcon = icon.innerHTML;

            if (success) {
                icon.innerHTML = '✓';
                button.classList.add('ac-codeblock-copy-success');
            } else {
                icon.innerHTML = '✗';
                button.classList.add('ac-codeblock-copy-error');
            }

            setTimeout(() => {
                icon.innerHTML = originalIcon;
                button.classList.remove('ac-codeblock-copy-success', 'ac-codeblock-copy-error');
            }, 2000);
        }

        internalValidateProperties(context) {
            super.internalValidateProperties(context);

            if (!this.code) {
                context.logParseEvent(
                    this,
                    AC.ValidationEvent.InvalidPropertyValue,
                    "CodeBlock must have code property"
                );
            }
        }

        toJSON() {
            const result = super.toJSON();

            result.code = this.code;

            if (this.language !== 'plaintext') {
                result.language = this.language;
            }
            if (this.lineNumbers) {
                result.lineNumbers = this.lineNumbers;
            }
            if (this.highlightLines.length > 0) {
                result.highlightLines = this.highlightLines;
            }
            if (this.caption) {
                result.caption = this.caption;
            }
            if (this.wrap) {
                result.wrap = this.wrap;
            }

            return result;
        }
    }

    // Register the CodeBlock element
    AC.GlobalRegistry.elements.register("CodeBlock", CodeBlock);

    // Expose for debugging
    if (typeof window !== 'undefined') {
        window.CodeBlockExtension = {
            CodeBlock
        };
    }

    console.log('CodeBlock extension loaded successfully');

})();
