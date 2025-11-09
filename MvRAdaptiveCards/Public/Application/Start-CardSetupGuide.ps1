
function Start-CardSetupGuide {
    param (

    )

    process {
        #Ask the user what they want to setup using Adaptive Cards (because hey - you can use Adaptive Cards for more than just MS Teams apps!)

        $Response = New-AdaptiveCard {
            New-CardTextBlock -Text "Welcome to the MvRAdaptiveCards Setup Wizard!" -Wrap -Size large

            New-CardTextBlock -Text "This wizard will guide you through the setup process. Please select the type of interface you want to set up:" -Wrap

            New-CardInputChoiceSet -Id "AppType" -Style expanded -Choices @{
                "TeamsApp" = "Publish cards in Microsoft Teams"
                "Smtp"     = "SMTP Configuration"
                # "Outlook"  = "Sending cards using Outlook"
            } -Placeholder "Select application type" -Value "TeamsApp"

        } -Actions {
            New-CardActionSubmit -Title "Next" -Style "Positive"
            New-CardActionSubmit -Title "Cancel" -Data @{ Action = "Cancel" } -Style "Destructive"
        }  | Get-CardResponse -PromptTitle "Setup Wizard" -ShowTitle:$false -ViewMethod EdgeApp -AutoSize -WindowWidth 600 -CardTitle "MvRAdaptiveCards Setup Wizard" -LogoHeaderText "MvRAdaptiveCards Setup Wizard"

        if ($Response.Action -eq "Cancel" -or $null -eq $Response) {
            Write-Host "Setup wizard cancelled by user."
            return
        }



        $_MvRACSettings = Get-CardSetting
        switch ($Response.AppType) {
            "TeamsApp" {
                Write-Information "Starting Teams App setup..."

                #Check if TeamsWebhook URL is already set

                if (![string]::IsNullOrWhiteSpace($_MvRACSettings.TeamsWebhook.WebhookUrl)) {
                    $UseExisting = New-AdaptiveCard {
                        New-CardTextBlock -Text "A Teams Webhook URL is already configured." -Wrap
                        New-CardTextBlock -Text "Would you like to use the existing Webhook URL or set up a new one?" -Wrap
                    } -Actions {
                        New-CardActionSubmit -Title "Use Existing" -Data @{ Action = "UseExisting" } -Style destructive
                        New-CardActionSubmit -Title "Set Up New" -Data @{ Action = "SetupNew" } -Style default
                    } | Get-CardResponse -PromptTitle "Existing Webhook URL" -ShowTitle:$false -ViewMethod EdgeApp -AutoSize -WindowWidth 400
                }

                if ($UseExisting.Action -eq "UseExisting") {
                    Write-Host "Using existing Teams Webhook URL. Setup complete."
                    return
                }


                try {

                    $WizardResponse = New-AdaptiveCard {
                        New-CardWizard -WizardPages {
                            New-CardTextBlock -Text "Step 1: Configure Teams channel workflow" -Size Large -Wrap

                            New-CardTextBlock -Text "Microsoft Teams can recieve Adaptive Cards via via webhook events using Incoming Webhooks. To set this up, please follow these steps:" -Wrap
                            New-CardTextBlock -Text "1. In **Microsoft Teams**, navigate to the desired channel where you want to post Adaptive Cards. `n*Be aware that **private channels** require **additional configuration** in order to work*." -Wrap

                            New-CardTextBlock -Text "2. Click on the ellipsis (three dots) next to the channel name and select '**Workflows**'." -Wrap
                            New-CardTextBlock -Text "3. Choose '**Create new workflow for incoming webhook**'." -Wrap
                            New-CardTextBlock -Text "4. Provide a **name** and **connection** (usually your account is already selected)." -Wrap
                            New-CardTextBlock -Text "Click '**next**' to continue to the next step." -Wrap
                        },
                        {
                            New-CardTextBlock -Text "Step 2: Complete the Workflow Setup" -Size Large -Wrap

                            New-CardTextBlock -Text "5. Check the **details** to make sure everything is correct." -Wrap
                            New-CardTextBlock -Text "6. Click '**Create workflow**' to finalize the workflow." -Wrap
                            New-CardTextBlock -Text "7. After creation, **copy** the provided **Webhook URL**. You will need this URL to send Adaptive Cards to this Teams channel." -Wrap
                            New-CardTextBlock -Text "Click '**next**' to continue to the next step." -Wrap


                        },
                        {
                            New-CardTextBlock -Text "Step 3: Set the webhook URL" -Size Large -Wrap

                            New-CardTextBlock -Text "8. **Paste** the copied **Webhook URL** into the text box below." -Wrap
                            New-CardInputText -Id "WebhookUrl" -Placeholder "Enter the Teams channel Webhook URL here"
                            New-CardInputChoiceSet -Id "TestCard" -Style expanded -Choices @{
                                "Yes" = "Yes, send a test Adaptive Card to the Teams channel now."
                                "No"  = "No, I will test it later."
                            } -Value "Yes" -Label "Would you like to send a test Adaptive Card to verify the setup?"

                        }

                    }  | Get-CardResponse -PromptTitle "Teams App Setup" -ShowTitle:$false -ViewMethod EdgeApp -AutoSize -WindowWidth 650 -CardTitle "MvRAdaptiveCards Setup Wizard" -LogoHeaderText "MvRAdaptiveCards Setup Wizard"
                }
                catch {
                    Write-Warning "Window closed by user or process interrupted. Exiting setup. "
                    return
                }

                if ($WizardResponse.Action -eq "Cancel" -or $null -eq $WizardResponse) {
                    Write-Host "Setup wizard cancelled by user."
                    return
                }

                if ( -not $WizardResponse.WebhookUrl) {
                    Write-Warning "No Webhook URL provided. Cannot proceed with Teams setup."
                    return
                }

                #test if the webhook URL is a valid URL
                try {
                    $uri = [uri]$WizardResponse.WebhookUrl
                }
                catch {
                    Write-Warning "The provided Webhook URL is not valid. Please check the URL and try again."
                    return
                }

                if ($WizardResponse.TestCard -eq "Yes" -and $WizardResponse.WebhookUrl) {
                    Write-Information "Sending test Adaptive Card to Teams channel..."
                    $TestCard = New-AdaptiveCard -Content {
                        New-CardColumnSet -Columns {
                            New-CardColumn -Width "Auto" -Content {
                                New-CardImage -Url $_MvRACSettings.General.LogoUrl -Size "Small" -AltText "Test Image"
                            }
                            New-CardColumn -Width "Stretch" -Content {
                                New-CardTextBlock -Text "Test MvRAdaptiveCards" -Size "Medium" -Weight "Bolder" -Wrap
                            }
                        }
                        New-CardTextBlock -Text "This is a test Adaptive Card sent from the MvRAdaptiveCards Setup Wizard." -Wrap

                    } -Actions {
                        New-CardActionOpenUrl -Title "Learn more about MvRAdaptiveCards" -Url "https://github.com/Michael19842/PowerShell.MvRAdaptiveCards.Module" -Style default


                    }

                    try {
                        Send-CardViaTeams -WebhookUrl $WizardResponse.WebhookUrl -CardJson $TestCard
                        Write-Host "Test Adaptive Card sent successfully to the Teams channel."
                    }
                    catch {
                        Write-Warning "Failed to send test Adaptive Card. Please check the Webhook URL and your network connection."
                        return
                    }

                    $CardRecieved = New-AdaptiveCard {
                        New-CardTextBlock -Text "Did you receive the test Adaptive Card in the Teams channel?" -Wrap

                    } -Actions {
                        New-CardActionSubmit -Title "Yes" -Data @{ Response = "Yes" } -Style Positive
                        New-CardActionSubmit -Title "No" -Data @{ Response = "No" } -Style Destructive
                    } | Get-CardResponse -PromptTitle "Test Card Confirmation" -ShowTitle:$false -ViewMethod EdgeApp -AutoSize -WindowWidth 400 -CardTitle "Test Card Confirmation" -LogoHeaderText "MvRAdaptiveCards Setup Wizard"

                    if ($CardRecieved.Response -eq "Yes") {
                        Write-ColoredHost "{green}[V]{white} Setup completed successfully. {gray}You can now send Adaptive Cards to the configured Teams channel using the provided Webhook URL."
                    }
                    else {
                        Write-Warning "It seems you did not receive the test Adaptive Card. Please verify the Webhook URL and try again."
                        return
                    }


                    $_MvRACSettings = Get-CardSetting

                    $_MvRACSettings.TeamsWebhook.WebhookUrl = $WizardResponse.WebhookUrl
                    #Set the webhook URL in the module settings for future use
                    Set-CardSetting -Settings $_MvRACSettings

                }



            }
            "Smtp" {
                Write-Information "Starting SMTP Configuration setup..."

                if (![string]::IsNullOrWhiteSpace(($_MvRACSettings.DefaultSmtpSettings.Server))) {
                    Write-Information "SMTP server is already configured"

                    $UseExistingSmtp = New-AdaptiveCard {
                        New-CardTextBlock -Text "SMTP server settings are already configured." -Wrap
                        New-CardTextBlock -Text "Would you like to use the existing SMTP settings or set up new ones?" -Wrap
                    } -Actions {
                        New-CardActionSubmit -Title "Use Existing" -Data @{ Action = "UseExistingSmtp" } -Style destructive
                        New-CardActionSubmit -Title "Set Up New" -Data @{ Action = "SetupNewSmtp" } -Style default
                    } | Get-CardResponse -PromptTitle "Existing SMTP Settings" -ShowTitle:$false -ViewMethod EdgeApp -AutoSize -WindowWidth 400 -CardTitle "MvRAdaptiveCards Setup Wizard" -LogoHeaderText "MvRAdaptiveCards Setup Wizard"

                    if ( $UseExistingSmtp.Action -eq "UseExistingSmtp") {
                        Write-Host "Using existing SMTP settings. Setup complete."
                        return
                    }
                }

                $SMTPResponse = New-AdaptiveCard {
                    New-CardTextBlock -Text "SMTP Configuration" -Size Large -Wrap

                    New-CardTextBlock -Text "Please enter the SMTP server settings below to configure email sending capabilities:" -Wrap
                    New-CardInputText -Id "From" -Placeholder "Sender Email Address" -Label "From Address" -IsRequired -Style "Email" -Regex "^[^@]+@[^@]+\.[^@]+$"
                    New-CardInputText -Id "Server" -Placeholder "SMTP Server Address" -Label "SMTP Server" -IsRequired
                    New-CardInputText -Id "Port" -Placeholder "SMTP Server Port" -Label "Port" -IsRequired -Value "587" -Style "Number" -Regex "^\d{1,5}$"
                    New-CardInputText -Id "Username" -Placeholder "SMTP Username" -Label "Username" -IsRequired
                    New-CardInputText -Id "Password" -Placeholder "SMTP Password" -Label "Password" -Style "Password" -IsRequired
                    New-CardInputToggle -Id "UseSsl" -Title "Use SSL/TLS" -Value "true" -Label "Enable SSL/TLS for SMTP connection"

                } -Actions {
                    New-CardActionSubmit -Title "Save Settings" -Style Positive
                } | Get-CardResponse -PromptTitle "SMTP Configuration" -ShowTitle:$false -ViewMethod EdgeApp -AutoSize -WindowWidth 500 -CardTitle "MvRAdaptiveCards Setup Wizard" -LogoHeaderText "MvRAdaptiveCards Setup Wizard"

                if ($SMTPResponse.Action -eq "Cancel" -or $null -eq $SMTPResponse) {
                    Write-Host "Setup wizard cancelled by user."
                    return
                }

                #Save SMTP settings to module settings
                $_MvRACSettings.DefaultSmtpSettings.From = $SMTPResponse.From
                $_MvRACSettings.DefaultSmtpSettings.Server = $SMTPResponse.Server
                $_MvRACSettings.DefaultSmtpSettings.Port = [int]$SMTPResponse.Port
                $_MvRACSettings.DefaultSmtpSettings.Username = $SMTPResponse.Username
                $_MvRACSettings.DefaultSmtpSettings.Password = $SMTPResponse.Password | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
                $_MvRACSettings.DefaultSmtpSettings.UseSsl = [bool]$SMTPResponse.UseSsl

                Set-CardSetting -Settings $_MvRACSettings

            }
            "Outlook" {
                Write-Information "Starting Outlook card sending setup..."
                # Call Outlook setup function here
            }
            default {
                Write-Warning "No valid application type selected. Exiting setup."
                return
            }
        }

    }

    end {
    }

}