#!/bin/bash

# Liste des VPC à nettoyer
VPCS=("vpc-039a9f5cb9c65544a" "vpc-0a5e36b580e309f52")

for VPC in "${VPCS[@]}"; do
    echo "🔍 Nettoyage du VPC $VPC ..."

    # 1. Detacher et supprimer les Internet Gateways
    IGW=$(aws ec2 describe-internet-gateways \
        --filters "Name=attachment.vpc-id,Values=$VPC" \
        --query "InternetGateways[].InternetGatewayId" \
        --output text)

    if [[ $IGW != "None" && $IGW != "" ]]; then
        echo "→ Détachement de l’IGW $IGW"
        aws ec2 detach-internet-gateway --internet-gateway-id $IGW --vpc-id $VPC
        echo "→ Suppression IGW $IGW"
        aws ec2 delete-internet-gateway --internet-gateway-id $IGW
    fi

    # 2. Supprimer les subnets
    SUBNETS=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VPC" --query "Subnets[].SubnetId" --output text)
    for SUB in $SUBNETS; do
        echo "→ Suppression du subnet $SUB"
        aws ec2 delete-subnet --subnet-id $SUB
    done

    # 3. Supprimer les interfaces réseau (ENI)
    ENIS=$(aws ec2 describe-network-interfaces --filters "Name=vpc-id,Values=$VPC" --query "NetworkInterfaces[].NetworkInterfaceId" --output text)
    for ENI in $ENIS; do
        echo "→ Suppression ENI $ENI"
        aws ec2 delete-network-interface --network-interface-id $ENI
    done

    # 4. Supprimer les Security Groups sauf "default"
    SGS=$(aws ec2 describe-security-groups \
        --filters "Name=vpc-id,Values=$VPC" \
        --query "SecurityGroups[?GroupName!='default'].GroupId" \
        --output text)

    for SG in $SGS; do
        echo "→ Suppression Security Group $SG"
        aws ec2 delete-security-group --group-id $SG
    done

    # 5. Supprimer les route tables (sauf main)
    RTBS=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC" \
        --query "RouteTables[?Associations[0].Main==null].RouteTableId" --output text)

    for RTB in $RTBS; do
        echo "→ Suppression Route Table $RTB"
        aws ec2 delete-route-table --route-table-id $RTB
    done

    # 6. Supprimer le VPC
    echo "→ Suppression du VPC $VPC"
    aws ec2 delete-vpc --vpc-id $VPC

    echo "✅ VPC $VPC supprimé avec succès."
    echo "-----------------------------------------"
done

echo "🎉 Nettoyage terminé !"
