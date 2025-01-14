$ruleName = "PSDSCDscTestsPresent"

if ($PSVersionTable.PSVersion -ge [Version]'5.0.0') {

 Describe "DscTestsPresent rule in class based resource" {

    $testsPath = "$PSScriptRoot\DSCResourceModule\DSCResources\MyDscResource\Tests"
    $classResourcePath = "$PSScriptRoot\DSCResourceModule\DSCResources\MyDscResource\MyDscResource.psm1"

    Context "When tests absent" {

        $violations = Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue $classResourcePath | Where-Object {$_.RuleName -eq $ruleName}
        $violationMessage = "No tests found for resource 'FileResource'"

        It "has 1 missing test violation" {
            $violations.Count | Should -Be 1
        }

        It "has the correct description message" {
            $violations[0].Message | Should -Be $violationMessage
        }
    }

    Context "When tests present" {
        New-Item -Path $testsPath -ItemType Directory -force
        New-Item -Path "$testsPath\FileResource_Test.psm1" -ItemType File -force

        $noViolations = Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue $classResourcePath | Where-Object {$_.RuleName -eq $ruleName}

        It "returns no violations" {
            $noViolations.Count | Should -Be 0
        }

        Remove-Item -Path $testsPath -Recurse -Force
    }
 }
}

Describe "DscTestsPresent rule in regular (non-class) based resource" {

    $testsPath = "$PSScriptRoot\DSCResourceModule\Tests"
    $resourcePath = "$PSScriptRoot\DSCResourceModule\DSCResources\MSFT_WaitForAll\MSFT_WaitForAll.psm1"

    Context "When tests absent" {

        $violations = Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue $resourcePath | Where-Object {$_.RuleName -eq $ruleName}
        $violationMessage = "No tests found for resource 'MSFT_WaitForAll'"

        It "has 1 missing tests violation" {
            $violations.Count | Should -Be 1
        }

        It "has the correct description message" {
            $violations[0].Message | Should -Be $violationMessage
        }
    }

    Context "When tests present" {
        New-Item -Path $testsPath -ItemType Directory -force
        New-Item -Path "$testsPath\MSFT_WaitForAll_Test.psm1" -ItemType File -force

        $noViolations = Invoke-ScriptAnalyzer -ErrorAction SilentlyContinue $resourcePath | Where-Object {$_.RuleName -eq $ruleName}

        It "returns no violations" {
            $noViolations.Count | Should -Be 0
        }

        Remove-Item -Path $testsPath -Recurse -Force
    }
}
