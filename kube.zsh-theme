# Kube Theme = Making it easier for any k8s admin

# helper functions to obtain kubernetes information
__kubernetes_context() {
    local context=''
    if type 'kubectl' > /dev/null; then
        context=$(kubectl config view -o=jsonpath='{.current-context}') 
    fi
    echo ${context}
}

__kubernetes_namespace() {
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

# Global Command Line settings
ZSH_THEME_GIT_PROMPT_DIRTY="$FG[160]✗"
ZSH_THEME_GIT_PROMPT_CLEAN="$FG[154]✓"
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[white]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[white]%})"

# Ensuring any errors outputted by kubectl is hidden
# to keep away any unneeded panic
PROMPT='%{$fg[cyan]%}[$(__kubernetes_context 2>/dev/null):$(__kubernetes_namespace 2>/dev/null)] \
%{$reset_color%}$FG[136]%~$(git_prompt_info)
%{$reset_color%}» '
