#! /bin/bash 

# Kube Theme - Making it easier for any k8s admin


# helper functions to obtain kubernetes information
function __kubernetes_context() {
    local context=''
    if type 'kubectl' > /dev/null; then
        context=$(kubectl config view -o=jsonpath='{.current-context}') 
    fi
    echo ${context}
}

function __kubernetes_namespace() {
    local namespace=''
    local context="$(__kubernetes_context)"
    if type 'kubectl' > /dev/null; then
        namespace="$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${context}\")].context.namespace}")"
        if [ -z "$namespace" ];then 
            namespace='default'
        fi
    fi
    echo "${namespace}"
}

# Global Command line settings
SCM_THEME_PROMPT_DIRTY="${orange}✗"
SCM_THEME_PROMPT_CLEAN="${green}✓"
SCM_THEME_PROMPT_PREFIX="${white}("
SCM_THEME_PROMPT_SUFFIX="${white})"

GIT_THEME_PROMPT_DIRTY="${orange}✗"
GIT_THEME_PROMPT_CLEAN="${green}✓"
GIT_THEME_PROMPT_PREFIX="${white}("
GIT_THEME_PROMPT_SUFFIX="${white})"

function prompt_command() {
    # Ensuring any warnings from kubectl are piped to dev null
    # to keep any unneeded panic underwraps
    PS1="\n${cyan}[$(__kubernetes_context 2>/dev/null):$(__kubernetes_namespace 2>/dev/null)] ${reset_color} ${grey}\w $(scm_prompt_info)${reset_color}\n» "
}

safe_append_prompt_command prompt_command
