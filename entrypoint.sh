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
