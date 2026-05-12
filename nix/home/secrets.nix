{
  config,
  lib,
  ...
}: let
  secretsFile = ../../secrets/secrets.yaml;
  secretsExist = builtins.pathExists secretsFile;
in {
  sops = lib.mkIf secretsExist {
    defaultSopsFile = secretsFile;
    age.keyFile = "/home/mier/.config/sops/age/keys.txt";

    secrets = {
      anthropic_base_url = {};
      jira_api_token = {};
      jwt_secret_key = {};
      openweathermap_api_key = {};
      pelayio_anthropic_base_url = {};
      pelayio_bedrock_base_url = {};
      pelayio_cohere_base_url = {};
      pelayio_gemini_base_url = {};
      pelayio_groq_base_url = {};
      pelayio_mistral_base_url = {};
      pelayio_openai_base_url = {};
      pelayio_together_base_url = {};
    };

    templates."fish-secrets.fish" = {
      content = ''
        set -gx ANTHROPIC_BASE_URL "${config.sops.placeholder.anthropic_base_url}"
        set -gx JIRA_API_TOKEN "${config.sops.placeholder.jira_api_token}"
        set -gx JWT_SECRET_KEY "${config.sops.placeholder.jwt_secret_key}"
        set -gx OPENWEATHERMAP_API_KEY "${config.sops.placeholder.openweathermap_api_key}"
        set -gx PELAYIO_ANTHROPIC_BASE_URL "${config.sops.placeholder.pelayio_anthropic_base_url}"
        set -gx PELAYIO_BEDROCK_BASE_URL "${config.sops.placeholder.pelayio_bedrock_base_url}"
        set -gx PELAYIO_COHERE_BASE_URL "${config.sops.placeholder.pelayio_cohere_base_url}"
        set -gx PELAYIO_GEMINI_BASE_URL "${config.sops.placeholder.pelayio_gemini_base_url}"
        set -gx PELAYIO_GROQ_BASE_URL "${config.sops.placeholder.pelayio_groq_base_url}"
        set -gx PELAYIO_MISTRAL_BASE_URL "${config.sops.placeholder.pelayio_mistral_base_url}"
        set -gx PELAYIO_OPENAI_BASE_URL "${config.sops.placeholder.pelayio_openai_base_url}"
        set -gx PELAYIO_TOGETHER_BASE_URL "${config.sops.placeholder.pelayio_together_base_url}"
      '';
    };
  };
}
