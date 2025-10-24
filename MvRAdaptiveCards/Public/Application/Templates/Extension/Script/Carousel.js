(function () {
    const AC = AdaptiveCards;

    // CarouselPage - Individual page within a carousel
    class CarouselPage extends AC.Container {
        constructor() {
            super();
            this._selectAction = undefined;
            this._customBackgroundImage = undefined;
        }

        getJsonTypeName() {
            return "CarouselPage";
        }

        parse(source, context) {
            super.parse(source, context);

            // Parse background image if present (store in custom property to avoid conflict)
            if (source.backgroundImage !== undefined) {
                this._customBackgroundImage = source.backgroundImage;
            }

            // Parse select action if present
            if (source.selectAction !== undefined) {
                this._selectAction = AC.createActionInstance(
                    source.selectAction,
                    context
                );
            }

            // Don't manually parse items - let the parent Container class handle it
            // The super.parse() call already handles items parsing
        }

        internalRender() {
            const pageElement = document.createElement('div');
            pageElement.className = 'ac-carousel-page';

            // Apply background image if specified
            if (this._customBackgroundImage) {
                if (typeof this._customBackgroundImage === 'string') {
                    pageElement.style.backgroundImage = `url(${this._customBackgroundImage})`;
                    pageElement.style.backgroundSize = 'cover';
                    pageElement.style.backgroundPosition = 'center';
                } else if (typeof this._customBackgroundImage === 'object') {
                    pageElement.style.backgroundImage = `url(${this._customBackgroundImage.url || ''})`;
                    pageElement.style.backgroundSize = this._customBackgroundImage.fillMode || 'cover';
                    pageElement.style.backgroundPosition = this._customBackgroundImage.horizontalAlignment || 'center';
                }
            }

            // Render all child items (including inputs)
            const renderedItems = super.internalRender();
            if (renderedItems) {
                pageElement.appendChild(renderedItems);
            }

            return pageElement;
        }

        toJSON() {
            const result = super.toJSON();

            if (this._customBackgroundImage) {
                result.backgroundImage = this._customBackgroundImage;
            }

            if (this._selectAction) {
                result.selectAction = this._selectAction.toJSON();
            }

            return result;
        }
    }

    // Carousel - Container for multiple pages with navigation
    class Carousel extends AC.Container {
        constructor() {
            super();
            this.pages = [];
            this.currentPageIndex = 0;
            this.timer = 0; // Auto-advance timer in milliseconds (0 = disabled)
            this.initialPage = 0;
            this.loop = false;
            this.heightInPixels = undefined;
            this._timerHandle = null;
        }

        getJsonTypeName() {
            return "Carousel";
        }

        parse(source, context) {
            // Transform pages to items for Container parsing
            if (source.pages !== undefined && Array.isArray(source.pages)) {
                // Create a modified source with items instead of pages
                const modifiedSource = { ...source };
                modifiedSource.items = source.pages;
                delete modifiedSource.pages;

                // Call super with modified source
                super.parse(modifiedSource, context);

                // Copy the parsed items to our pages array
                this.pages = Array.from(this._items || []);
            } else {
                super.parse(source, context);
            }

            // Parse timer
            if (source.timer !== undefined) {
                this.timer = source.timer;
            }

            // Parse initial page
            if (source.initialPage !== undefined) {
                this.initialPage = source.initialPage;
                this.currentPageIndex = this.initialPage;
            }

            // Parse loop setting
            if (source.loop !== undefined) {
                this.loop = source.loop;
            }

            // Parse height
            if (source.heightInPixels !== undefined) {
                this.heightInPixels = source.heightInPixels;
            }
        }

        internalRender() {
            const carouselContainer = document.createElement('div');
            carouselContainer.className = 'ac-carousel-container';

            if (this.heightInPixels) {
                carouselContainer.style.height = `${this.heightInPixels}px`;
            }

            // Pages container
            const pagesContainer = document.createElement('div');
            pagesContainer.className = 'ac-carousel-pages';

            // Render all pages
            this.pages.forEach((page, index) => {
                const pageWrapper = document.createElement('div');
                pageWrapper.className = 'ac-carousel-page-wrapper';
                pageWrapper.style.display = index === this.currentPageIndex ? 'block' : 'none';

                const renderedPage = page.internalRender();
                if (renderedPage) {
                    pageWrapper.appendChild(renderedPage);
                }

                pagesContainer.appendChild(pageWrapper);
            });

            carouselContainer.appendChild(pagesContainer);

            // Navigation controls
            if (this.pages.length > 1) {
                const navContainer = document.createElement('div');
                navContainer.className = 'ac-carousel-nav';

                // Previous button
                const prevButton = document.createElement('button');
                prevButton.className = 'ac-carousel-nav-button ac-carousel-prev';
                prevButton.innerHTML = '‹';
                prevButton.setAttribute('aria-label', 'Previous page');
                prevButton.onclick = () => this.navigateToPrevPage(carouselContainer);
                navContainer.appendChild(prevButton);

                // Page indicators
                const indicatorsContainer = document.createElement('div');
                indicatorsContainer.className = 'ac-carousel-indicators';

                this.pages.forEach((_, index) => {
                    const indicator = document.createElement('button');
                    indicator.className = 'ac-carousel-indicator';
                    indicator.setAttribute('aria-label', `Go to page ${index + 1}`);
                    if (index === this.currentPageIndex) {
                        indicator.classList.add('active');
                    }
                    indicator.onclick = () => this.navigateToPage(index, carouselContainer);
                    indicatorsContainer.appendChild(indicator);
                });

                navContainer.appendChild(indicatorsContainer);

                // Next button
                const nextButton = document.createElement('button');
                nextButton.className = 'ac-carousel-nav-button ac-carousel-next';
                nextButton.innerHTML = '›';
                nextButton.setAttribute('aria-label', 'Next page');
                nextButton.onclick = () => this.navigateToNextPage(carouselContainer);
                navContainer.appendChild(nextButton);

                carouselContainer.appendChild(navContainer);

                // Update navigation state
                this.updateNavigation(carouselContainer);

                // Start auto-advance timer if configured
                if (this.timer > 0) {
                    this.startAutoAdvance(carouselContainer);
                }
            }

            return carouselContainer;
        }

        navigateToPage(pageIndex, container) {
            if (pageIndex < 0 || pageIndex >= this.pages.length) {
                return;
            }

            // Stop auto-advance when user manually navigates
            this.stopAutoAdvance();

            const oldIndex = this.currentPageIndex;
            this.currentPageIndex = pageIndex;

            // Hide all pages
            const pageWrappers = container.querySelectorAll('.ac-carousel-page-wrapper');
            pageWrappers.forEach((wrapper, index) => {
                wrapper.style.display = index === pageIndex ? 'block' : 'none';
            });

            // Update indicators
            const indicators = container.querySelectorAll('.ac-carousel-indicator');
            indicators.forEach((indicator, index) => {
                if (index === pageIndex) {
                    indicator.classList.add('active');
                } else {
                    indicator.classList.remove('active');
                }
            });

            // Update navigation buttons
            this.updateNavigation(container);

            // Restart auto-advance if it was enabled
            if (this.timer > 0) {
                this.startAutoAdvance(container);
            }
        }

        navigateToNextPage(container) {
            let nextIndex = this.currentPageIndex + 1;

            if (nextIndex >= this.pages.length) {
                if (this.loop) {
                    nextIndex = 0;
                } else {
                    return; // Don't advance beyond last page if not looping
                }
            }

            this.navigateToPage(nextIndex, container);
        }

        navigateToPrevPage(container) {
            let prevIndex = this.currentPageIndex - 1;

            if (prevIndex < 0) {
                if (this.loop) {
                    prevIndex = this.pages.length - 1;
                } else {
                    return; // Don't go before first page if not looping
                }
            }

            this.navigateToPage(prevIndex, container);
        }

        updateNavigation(container) {
            const prevButton = container.querySelector('.ac-carousel-prev');
            const nextButton = container.querySelector('.ac-carousel-next');

            if (!prevButton || !nextButton) return;

            // Enable/disable prev button
            if (this.currentPageIndex === 0 && !this.loop) {
                prevButton.disabled = true;
                prevButton.style.opacity = '0.3';
            } else {
                prevButton.disabled = false;
                prevButton.style.opacity = '1';
            }

            // Enable/disable next button
            if (this.currentPageIndex === this.pages.length - 1 && !this.loop) {
                nextButton.disabled = true;
                nextButton.style.opacity = '0.3';
            } else {
                nextButton.disabled = false;
                nextButton.style.opacity = '1';
            }
        }

        startAutoAdvance(container) {
            this.stopAutoAdvance();

            if (this.timer > 0) {
                this._timerHandle = setInterval(() => {
                    this.navigateToNextPage(container);
                }, this.timer);
            }
        }

        stopAutoAdvance() {
            if (this._timerHandle) {
                clearInterval(this._timerHandle);
                this._timerHandle = null;
            }
        }

        toJSON() {
            const result = super.toJSON();

            if (this.pages.length > 0) {
                result.pages = this.pages.map(page => page.toJSON());
            }

            if (this.timer !== 0) {
                result.timer = this.timer;
            }

            if (this.initialPage !== 0) {
                result.initialPage = this.initialPage;
            }

            if (this.loop) {
                result.loop = this.loop;
            }

            if (this.heightInPixels) {
                result.heightInPixels = this.heightInPixels;
            }

            return result;
        }
    }

    // Register both Carousel and CarouselPage
    AC.GlobalRegistry.elements.register("Carousel", Carousel);
    AC.GlobalRegistry.elements.register("CarouselPage", CarouselPage);

    // Expose for debugging
    if (typeof window !== 'undefined') {
        window.CarouselExtension = {
            Carousel,
            CarouselPage
        };
    }

    console.log('Carousel extension loaded successfully');

})();
