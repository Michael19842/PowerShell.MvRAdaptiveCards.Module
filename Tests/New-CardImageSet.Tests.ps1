BeforeAll {
    # Import the module
    $ModulePath = Join-Path -Path $PSScriptRoot -ChildPath '..\MvRAdaptiveCards\MvRAdaptiveCards.psd1'
    Import-Module $ModulePath -Force
}

Describe 'New-CardImageSet' {

    Context 'Basic Functionality' {
        It 'Should create a basic ImageSet with required parameters' {
            $result = New-CardImageSet -Images {
                @{
                    type    = "Image"
                    url     = "https://example.com/test.jpg"
                    altText = "Test Image"
                }
            }

            $result | Should -BeOfType [hashtable]
            $result.type | Should -Be "ImageSet"
            $result.images | Should -Not -BeNullOrEmpty
            $result.images.url | Should -Be "https://example.com/test.jpg"
            $result.images.altText | Should -Be "Test Image"
        }

        It 'Should handle multiple images in the scriptblock' {
            $result = New-CardImageSet -Images {
                @{
                    type    = "Image"
                    url     = "https://example.com/image1.jpg"
                    altText = "Image 1"
                }
                @{
                    type    = "Image"
                    url     = "https://example.com/image2.jpg"
                    altText = "Image 2"
                }
            }

            $result.images | Should -HaveCount 2
            $result.images[0].url | Should -Be "https://example.com/image1.jpg"
            $result.images[1].url | Should -Be "https://example.com/image2.jpg"
        }

        It 'Should execute the Images scriptblock properly' {
            $mockImages = @(
                @{ type = "Image"; url = "https://example.com/1.jpg"; altText = "Image 1" }
                @{ type = "Image"; url = "https://example.com/2.jpg"; altText = "Image 2" }
                @{ type = "Image"; url = "https://example.com/3.jpg"; altText = "Image 3" }
            )

            $result = New-CardImageSet -Images { $mockImages }

            $result.images | Should -HaveCount 3
            $result.images[2].url | Should -Be "https://example.com/3.jpg"
        }
    }

    Context 'ImageSize Parameter' {
        It 'Should set imageSize when ImageSize parameter is provided' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -ImageSize "Large"

            $result.imageSize | Should -Be "Large"
        }

        It 'Should accept Small as ImageSize' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -ImageSize "Small"

            $result.imageSize | Should -Be "Small"
        }

        It 'Should accept Medium as ImageSize' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -ImageSize "Medium"

            $result.imageSize | Should -Be "Medium"
        }

        It 'Should not include imageSize property when not specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            }

            $result.ContainsKey('imageSize') | Should -Be $false
        }
    }

    Context 'Layout and Alignment Properties' {
        It 'Should set horizontal alignment when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -HorizontalAlignment "Center"

            $result.horizontalAlignment | Should -Be "Center"
        }

        It 'Should accept all valid horizontal alignment values' {
            $alignments = @("Left", "Center", "Right")

            foreach ($alignment in $alignments) {
                $result = New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -HorizontalAlignment $alignment

                $result.horizontalAlignment | Should -Be $alignment
            }
        }

        It 'Should set height when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Height "Stretch"

            $result.height | Should -Be "Stretch"
        }

        It 'Should accept Auto and Stretch as height values' {
            $heights = @("Auto", "Stretch")

            foreach ($height in $heights) {
                $result = New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -Height $height

                $result.height | Should -Be $height
            }
        }

        It 'Should set grid area when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -GridArea "image-gallery"

            $result.gridArea | Should -Be "image-gallery"
        }
    }

    Context 'Styling Properties' {
        It 'Should set background color when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -BackgroundColor "Light"

            $result.backgroundColor | Should -Be "Light"
        }

        It 'Should accept all valid background color values' {
            $colors = @("Default", "Dark", "Light", "Accent", "Good", "Warning", "Attention")

            foreach ($color in $colors) {
                $result = New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -BackgroundColor $color

                $result.backgroundColor | Should -Be $color
            }
        }

        It 'Should set spacing when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Spacing "Large"

            $result.spacing | Should -Be "Large"
        }

        It 'Should accept all valid spacing values' {
            $spacings = @("None", "Small", "Default", "Medium", "Large", "ExtraLarge", "Padding")

            foreach ($spacing in $spacings) {
                $result = New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -Spacing $spacing

                $result.spacing | Should -Be $spacing
            }
        }
    }

    Context 'Identification and Metadata' {
        It 'Should set ID when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Id "gallery-001"

            $result.id | Should -Be "gallery-001"
        }

        It 'Should set language when specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Language "en-US"

            $result.lang | Should -Be "en-US"
        }

        It 'Should set language when Lang alias is used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Lang "fr-FR"

            $result.lang | Should -Be "fr-FR"
        }
    }

    Context 'Switch Parameters' {
        It 'Should set separator when Separator switch is used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Separator

            $result.separator | Should -Be $true
        }

        It 'Should not include separator property when switch is not used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            }

            $result.ContainsKey('separator') | Should -Be $false
        }

        It 'Should set isSortKey when IsSortKey switch is used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -IsSortKey

            $result.isSortKey | Should -Be $true
        }

        It 'Should set isVisible to false when IsHidden switch is used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -IsHidden

            $result.isVisible | Should -Be $false
        }

        It 'Should set isVisible to false when Hide alias is used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Hide

            $result.isVisible | Should -Be $false
        }

        It 'Should not include visibility property when IsHidden is not used' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            }

            $result.ContainsKey('isVisible') | Should -Be $false
        }
    }

    Context 'Fallback Functionality' {
        It 'Should execute fallback scriptblock when provided' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -Fallback {
                @{
                    type = "TextBlock"
                    text = "Images not available"
                }
            }

            $result.fallback | Should -Not -BeNullOrEmpty
            $result.fallback.type | Should -Be "TextBlock"
            $result.fallback.text | Should -Be "Images not available"
        }

        It 'Should not include fallback property when not specified' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            }

            $result.ContainsKey('fallback') | Should -Be $false
        }
    }

    Context 'Complex Scenarios' {
        It 'Should handle all parameters together' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/1.jpg"; altText = "Image 1" }
                @{ type = "Image"; url = "https://example.com/2.jpg"; altText = "Image 2" }
            } -ImageSize "Large" -BackgroundColor "Light" -HorizontalAlignment "Center" -Height "Auto" -Spacing "Medium" -Id "main-gallery" -Language "en-US" -Separator -IsSortKey -Fallback {
                @{ type = "TextBlock"; text = "Gallery unavailable" }
            }

            $result.type | Should -Be "ImageSet"
            $result.images | Should -HaveCount 2
            $result.imageSize | Should -Be "Large"
            $result.backgroundColor | Should -Be "Light"
            $result.horizontalAlignment | Should -Be "Center"
            $result.height | Should -Be "Auto"
            $result.spacing | Should -Be "Medium"
            $result.id | Should -Be "main-gallery"
            $result.lang | Should -Be "en-US"
            $result.separator | Should -Be $true
            $result.isSortKey | Should -Be $true
            $result.fallback.text | Should -Be "Gallery unavailable"
        }

        It 'Should create ImageSet for different image types' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/photo.jpg"; altText = "Photo" }
                @{ type = "Image"; url = "https://example.com/icon.png"; altText = "Icon" }
                @{ type = "Image"; url = "https://example.com/diagram.svg"; altText = "Diagram" }
            } -ImageSize "Medium"

            $result.images | Should -HaveCount 3
            $result.images[0].altText | Should -Be "Photo"
            $result.images[1].altText | Should -Be "Icon"
            $result.images[2].altText | Should -Be "Diagram"
            $result.imageSize | Should -Be "Medium"
        }
    }

    Context 'ShouldProcess Support' {
        It 'Should support WhatIf parameter' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            } -WhatIf

            # WhatIf should not return anything
            $result | Should -BeNullOrEmpty
        }

        It 'Should return ImageSet when not using WhatIf' {
            $result = New-CardImageSet -Images {
                @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            }

            $result | Should -Not -BeNullOrEmpty
            $result.type | Should -Be "ImageSet"
        }
    }

    Context 'Parameter Validation' {
        It 'Should throw error for invalid ImageSize values' {
            { New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -ImageSize "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Height values' {
            { New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -Height "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid HorizontalAlignment values' {
            { New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -HorizontalAlignment "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid BackgroundColor values' {
            { New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -BackgroundColor "Invalid" } | Should -Throw
        }

        It 'Should throw error for invalid Spacing values' {
            { New-CardImageSet -Images {
                    @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
                } -Spacing "Invalid" } | Should -Throw
        }

        It 'Should require Images parameter' {
            { New-CardImageSet -Images $Null } | Should -Throw
        }
    }

    Context 'Edge Cases' {
        It 'Should handle empty Images scriptblock gracefully' {
            $result = New-CardImageSet -Images { }

            $result.type | Should -Be "ImageSet"
            # The images property should still be set but empty
            $result.ContainsKey('images') | Should -Be $true
        }

        It 'Should handle single image in array format' {
            $result = New-CardImageSet -Images {
                , @{ type = "Image"; url = "https://example.com/test.jpg"; altText = "Test" }
            }

            $result.images | Should -Not -BeNullOrEmpty
            $result.images.url | Should -Be "https://example.com/test.jpg"
        }

        It 'Should preserve image properties from scriptblock' {
            $result = New-CardImageSet -Images {
                @{
                    type    = "Image"
                    url     = "https://example.com/test.jpg"
                    altText = "Test Image"
                    size    = "Large"
                    style   = "Person"
                    width   = "100px"
                    height  = "100px"
                }
            }

            $result.images.url | Should -Be "https://example.com/test.jpg"
            $result.images.altText | Should -Be "Test Image"
            $result.images.size | Should -Be "Large"
            $result.images.style | Should -Be "Person"
            $result.images.width | Should -Be "100px"
            $result.images.height | Should -Be "100px"
        }
    }
}