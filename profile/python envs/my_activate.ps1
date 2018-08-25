# This file must be dot sourced from PoSh; you cannot run it
# directly. Do this: . ./activate.ps1

# FIXME: clean up unused vars.
$script:THIS_PATH = $myinvocation.mycommand.path
$script:BASE_DIR = split-path (resolve-path "$THIS_PATH/..") -Parent
$script:DIR_NAME = split-path $BASE_DIR -Leaf

function global:deactivate ( [switch] $NonDestructive ){

    # This line added for my personal prompt
    $NonDestructive = $TRUE

    if ( test-path variable:_OLD_VIRTUAL_PATH ) {
        $env:PATH = $variable:_OLD_VIRTUAL_PATH
        remove-variable "_OLD_VIRTUAL_PATH" -scope global
    }

    if ( test-path function:_old_virtual_prompt ) {
        $function:prompt = $function:_old_virtual_prompt
        remove-item function:\_old_virtual_prompt
    }

    if ($env:VIRTUAL_ENV) {
        $old_env = split-path $env:VIRTUAL_ENV -leaf
        remove-item env:VIRTUAL_ENV -erroraction silentlycontinue
    }

    if ( !$NonDestructive ) {
        # Self destruct!
        remove-item function:deactivate
    }

    # This line added for my personal prompt
    $GitPromptSettings.DefaultPromptPrefix = '`n';
}

# unset irrelevant variables
deactivate -nondestructive

$VIRTUAL_ENV = $BASE_DIR
$env:VIRTUAL_ENV = $VIRTUAL_ENV

$global:_OLD_VIRTUAL_PATH = $env:PATH
$env:PATH = "$env:VIRTUAL_ENV/Scripts;" + $env:PATH
if (! $env:VIRTUAL_ENV_DISABLE_PROMPT) {
    function global:_old_virtual_prompt { "" }
    $function:_old_virtual_prompt = $function:prompt

    # Lines below edited for my personal prompt
    $GitPromptSettings.DefaultPromptPrefix = '';
    function global:prompt {
        # Add a prefix to the current prompt, but don't discard it.
        write-host "`n($(split-path $env:VIRTUAL_ENV -leaf)) " -nonewline -f Green
        & $function:_old_virtual_prompt
    }
    # function global:prompt {
    #     # Add a prefix to the current prompt, but don't discard it.
    #     write-host "($(split-path $env:VIRTUAL_ENV -leaf)) " -nonewline
    #     & $function:_old_virtual_prompt
    # }
}
