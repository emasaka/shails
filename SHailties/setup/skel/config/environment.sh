## load check
if [[ -n "$LOADED_config_environment_sh" ]]; then return ; fi
LOADED_config_environment_sh=1

SHAILS_ENV='development'

logger.level ERROR
