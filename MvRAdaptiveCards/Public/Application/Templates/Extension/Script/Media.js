(function () {
    const AC = AdaptiveCards;

    // Enhanced Media element with YouTube/Vimeo support
    class EnhancedMedia extends AC.CardElement {
        constructor() {
            super();
            this.sources = [];
            this.poster = undefined;
            this.altText = undefined;
            this.captionSources = [];
        }

        getJsonTypeName() {
            return "Media";
        }

        parse(source, context) {
            super.parse(source, context);

            if (source.sources !== undefined && Array.isArray(source.sources)) {
                this.sources = source.sources;
            }

            if (source.poster !== undefined) {
                this.poster = source.poster;
            }

            if (source.altText !== undefined) {
                this.altText = source.altText;
            }

            if (source.captionSources !== undefined && Array.isArray(source.captionSources)) {
                this.captionSources = source.captionSources;
            }
        }

        internalRender() {
            if (!this.sources || this.sources.length === 0) {
                return null;
            }

            const container = document.createElement('div');
            container.className = 'ac-media-container';
            container.style.width = '100%';
            container.style.maxWidth = '100%';

            const source = this.sources[0];
            const mimeType = source.mimeType || '';
            const url = source.url || '';

            // Detect video type
            if (this.isYouTubeUrl(url) || mimeType.includes('youtube')) {
                return this.renderYouTube(url, container);
            } else if (this.isVimeoUrl(url) || mimeType.includes('vimeo')) {
                return this.renderVimeo(url, container);
            } else if (mimeType.startsWith('video/') || url.match(/\.(mp4|webm|ogg)$/i)) {
                return this.renderVideo(source, container);
            } else if (mimeType.startsWith('audio/') || url.match(/\.(mp3|wav|ogg|m4a)$/i)) {
                return this.renderAudio(source, container);
            }

            // Fallback
            const errorText = document.createElement('p');
            errorText.textContent = this.altText || 'Media format not supported';
            errorText.style.color = '#999';
            container.appendChild(errorText);
            return container;
        }

        isYouTubeUrl(url) {
            return url.includes('youtube.com') || url.includes('youtu.be');
        }

        isVimeoUrl(url) {
            return url.includes('vimeo.com');
        }

        extractYouTubeId(url) {
            const patterns = [
                /(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\s]+)/,
                /youtube\.com\/embed\/([^&\s]+)/
            ];

            for (const pattern of patterns) {
                const match = url.match(pattern);
                if (match && match[1]) {
                    return match[1];
                }
            }
            return null;
        }

        extractVimeoId(url) {
            const match = url.match(/vimeo\.com\/(\d+)/);
            return match ? match[1] : null;
        }

        renderYouTube(url, container) {
            const videoId = this.extractYouTubeId(url);
            if (!videoId) {
                const error = document.createElement('p');
                error.textContent = 'Invalid YouTube URL';
                error.style.color = '#d13438';
                container.appendChild(error);
                return container;
            }

            const iframe = document.createElement('iframe');
            iframe.src = `https://www.youtube.com/embed/${videoId}`;
            iframe.width = '100%';
            iframe.height = '315';
            iframe.style.border = 'none';
            iframe.style.borderRadius = '8px';
            iframe.allow = 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture';
            iframe.allowFullscreen = true;

            if (this.altText) {
                iframe.title = this.altText;
            }

            container.appendChild(iframe);
            return container;
        }

        renderVimeo(url, container) {
            const videoId = this.extractVimeoId(url);
            if (!videoId) {
                const error = document.createElement('p');
                error.textContent = 'Invalid Vimeo URL';
                error.style.color = '#d13438';
                container.appendChild(error);
                return container;
            }

            const iframe = document.createElement('iframe');
            iframe.src = `https://player.vimeo.com/video/${videoId}`;
            iframe.width = '100%';
            iframe.height = '315';
            iframe.style.border = 'none';
            iframe.style.borderRadius = '8px';
            iframe.allow = 'autoplay; fullscreen; picture-in-picture';
            iframe.allowFullscreen = true;

            if (this.altText) {
                iframe.title = this.altText;
            }

            container.appendChild(iframe);
            return container;
        }

        renderVideo(source, container) {
            const video = document.createElement('video');
            video.controls = true;
            video.style.width = '100%';
            video.style.maxWidth = '100%';
            video.style.borderRadius = '8px';

            if (this.poster) {
                video.poster = this.poster;
            }

            if (this.altText) {
                video.setAttribute('aria-label', this.altText);
            }

            // Add source
            const sourceElement = document.createElement('source');
            sourceElement.src = source.url;
            sourceElement.type = source.mimeType;
            video.appendChild(sourceElement);

            // Add captions
            if (this.captionSources && this.captionSources.length > 0) {
                this.captionSources.forEach((caption, index) => {
                    const track = document.createElement('track');
                    track.kind = 'subtitles';
                    track.src = caption.url;
                    track.srclang = caption.label || 'en';
                    track.label = caption.label || 'English';
                    if (index === 0) {
                        track.default = true;
                    }
                    video.appendChild(track);
                });
            }

            // Fallback text
            const fallback = document.createElement('p');
            fallback.textContent = 'Your browser does not support the video element.';
            video.appendChild(fallback);

            container.appendChild(video);
            return container;
        }

        renderAudio(source, container) {
            const audio = document.createElement('audio');
            audio.controls = true;
            audio.style.width = '100%';

            if (this.altText) {
                audio.setAttribute('aria-label', this.altText);
            }

            // Add source
            const sourceElement = document.createElement('source');
            sourceElement.src = source.url;
            sourceElement.type = source.mimeType;
            audio.appendChild(sourceElement);

            // Fallback text
            const fallback = document.createElement('p');
            fallback.textContent = 'Your browser does not support the audio element.';
            audio.appendChild(fallback);

            container.appendChild(audio);
            return container;
        }

        toJSON() {
            const result = super.toJSON();

            if (this.sources.length > 0) {
                result.sources = this.sources;
            }

            if (this.poster) {
                result.poster = this.poster;
            }

            if (this.altText) {
                result.altText = this.altText;
            }

            if (this.captionSources.length > 0) {
                result.captionSources = this.captionSources;
            }

            return result;
        }
    }

    // Register the enhanced Media element
    AC.GlobalRegistry.elements.unregister("Media");
    AC.GlobalRegistry.elements.register("Media", EnhancedMedia);

    // Expose for debugging
    if (typeof window !== 'undefined') {
        window.MediaExtension = {
            EnhancedMedia
        };
    }

    console.log('Enhanced Media extension loaded successfully with YouTube/Vimeo support');

})();
