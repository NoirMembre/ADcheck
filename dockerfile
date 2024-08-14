# Python:3.12.5-alpine3.20 comme image de base
FROM python:3.12.5-alpine3.20

# Installation des dépendances
RUN apk update && apk add --no-cache --update \
	git \
	bash \
	&& rm -rf ~/.cache/* /usr/local/share/man /tmp/*   
CMD /bin/bash
# Installer pipx
RUN python -m pip install pipx
RUN python -m pipx ensurepath
RUN python -m pipx completions

# Définir le répertoire de travail
WORKDIR /app

# Installer le projet ADcheck
RUN pipx install git+https://github.com/CobblePot59/ADcheck.git

# Copier les fichiers du projet dans le répertoire de travail
RUN cp /root/.local/bin/ADcheck /app && rm -rf /root/.local/bin

# Définir les variables d'environnement
ENV DOMAIN_NAME="test.lan"
ENV USERNAME="usertest"
ENV PASSWORD="fakepassword"
ENV DC_IP="192.168.0.1"

ENV PATH="/app:$PATH"

# Définir la commande pour exécuter l'application
CMD ["ADcheck", "-d $DOMAIN_NAME", "-u $USERNAME" -p $PASSWORD --dc-ip $DC_IP"]

----------

# Utiliser Python:3.12.5-alpine3.20 comme image de base
FROM python:3.12.5-alpine3.20

# Installation des dépendances
RUN apk update && apk add --no-cache --update \
    git \
    bash \
    && rm -rf ~/.cache/* /usr/local/share/man /tmp/*

# Installer pipx et ADcheck
RUN python -m pip install pipx && \
    python -m pipx ensurepath && \
    python -m pipx completions && \
    pipx install git+https://github.com/CobblePot59/ADcheck.git

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers du projet dans le répertoire de travail
RUN cp /root/.local/bin/ADcheck /app

# Définir les variables d'environnement
ENV DOMAIN_NAME="test.lan"
ENV USERNAME="usertest"
ENV PASSWORD="fakepassword"
ENV DC_IP="192.168.0.1"

ENV PATH="/app:$PATH"

# Définir la commande pour exécuter l'application
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
CMD ["/entrypoint.sh"]

----------
#entrypoint.sh
#!/bin/bash

# Vérifier les options obligatoires
if [ -z "$USERNAME" ] || [ -z "$DC_IP" ]; then
    echo "Les options -u USERNAME et --dc-ip DC_IP sont obligatoires."
    exit 1
fi

# Construire la commande de base
CMD="ADcheck -u $USERNAME --dc-ip $DC_IP"

# Ajouter les options facultatives si elles sont définies
case "$1" in
    -h)
        CMD="$CMD -h"
        ;;
    -d)
        CMD="$CMD -d $DOMAIN_NAME"
        ;;
    -p)
        CMD="$CMD -p $PASSWORD"
        ;;
    -H)
        CMD="$CMD -H $HASHES"
        ;;
    -s)
        CMD="$CMD -s"
        ;;
    -L)
        CMD="$CMD -L"
        ;;
    -M)
        CMD="$CMD -M $MODULE"
        ;;
    -o)
        CMD="$CMD -o"
        ;;
    --debug)
        CMD="$CMD --debug"
        ;;
    *)
        echo "Option non reconnue: $1"
        exit 1
        ;;
esac

# Exécuter la commande
eval $CMD
