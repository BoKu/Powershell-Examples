@{
    Severity     = @('Error', 'Warning')
    ExcludeRules = @(
        # New-*/Set-* here only build in-memory controls, so -WhatIf/-Confirm would add noise.
        'PSUseShouldProcessForStateChangingFunctions'
    )
}
