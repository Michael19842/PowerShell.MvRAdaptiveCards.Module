# Security Policy

## Supported Versions

We actively support the following versions of MvRAdaptiveCards with security updates:

| Version | Supported          |
| ------- | ------------------ |
| Latest  | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take security vulnerabilities seriously. If you discover a security vulnerability in MvRAdaptiveCards, please report it to us privately to allow us to address it before public disclosure.

### How to Report
Create a private security advisory through GitHub's security tab for this repository.

### What to Include

Please provide the following information when reporting a vulnerability:

- A detailed description of the vulnerability
- Steps to reproduce the issue
- Affected versions of the module
- Potential impact assessment
- Any suggested fixes or mitigations

## Security Considerations

### PowerShell Execution

- **Execution Policy**: Ensure your PowerShell execution policy is appropriately configured
- **Script Signing**: Consider using signed scripts in production environments
- **Least Privilege**: Run PowerShell with the minimum required privileges

## Incident Response

In the event of a security incident:

1. **Immediate Response**: Isolate affected systems if necessary
2. **Assessment**: Determine the scope and impact of the incident
3. **Notification**: Notify affected users and stakeholders as appropriate
4. **Remediation**: Implement fixes and security patches
5. **Post-Incident**: Conduct a post-incident review and update security measures

## Security Resources

### External Resources

- [PowerShell Security Best Practices](https://docs.microsoft.com/en-us/powershell/scripting/dev-cross-plat/security/powershell-security-best-practices)
- [Adaptive Cards Security Guidelines](https://docs.microsoft.com/en-us/adaptive-cards/authoring-cards/security)
- [Microsoft Security Development Lifecycle](https://www.microsoft.com/en-us/securityengineering/sdl)

### Tools

- [PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer) - PowerShell static code analysis
- [Pester](https://pester.dev/) - PowerShell testing framework

## Updates to This Policy

This security policy may be updated periodically to reflect changes in our security practices or to address new security concerns. Check this document regularly for updates.

---

**Last Updated**: November 2025
**Version**: 1.0

For questions about this security policy, please contact the maintainers through the project's GitHub repository.