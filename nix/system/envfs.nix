{
  # expone /bin/* y /usr/bin/* dinámicamente buscando en $PATH (FUSE).
  # necesario para scripts/plugins externos que asumen FHS (ej: shebangs #!/bin/bash).
  services.envfs.enable = true;
}
