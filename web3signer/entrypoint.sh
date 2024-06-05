#!/bin/bash

export KEYFILES_DIR="/data/keyfiles"
export NETWORK="prater"
export WEB3SIGNER_API="http://web3signer.web3signer-${NETWORK}.dappnode:9000"

# Assign proper value to _DAPPNODE_GLOBAL_CONSENSUS_CLIENT_PRATER. The UI uses the web3signer domain in the Header "Host"
case "$_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_PRATER" in
"prysm-prater.dnp.dappnode.eth")
  ETH2_CLIENT_DNS="validator.prysm-prater.dappnode"
  ;;
"teku-prater.dnp.dappnode.eth")
  ETH2_CLIENT_DNS="validator.teku-prater.dappnode"
  ;;
"lighthouse-prater.dnp.dappnode.eth")
  ETH2_CLIENT_DNS="validator.lighthouse-prater.dappnode"
  ;;
"nimbus-prater.dnp.dappnode.eth")
  ETH2_CLIENT_DNS="beacon-validator.nimbus-prater.dappnode"
  ;;
"lodestar-prater.dnp.dappnode.eth")
  ETH2_CLIENT_DNS="validator.lodestar-prater.dappnode"
  ;;
*)
  echo "_DAPPNODE_GLOBAL_CONSENSUS_CLIENT_PRATER env is not set properly"
  exit 1
  ;;
esac

# IMPORTANT! The dir defined for --key-store-path must exist and have specific permissions. Should not be created with a docker volume
mkdir -p "$KEYFILES_DIR"

if grep -Fq "/opt/web3signer/keyfiles" ${KEYFILES_DIR}/*.yaml; then
  sed -i "s|/opt/web3signer/keyfiles|$KEYFILES_DIR|g" ${KEYFILES_DIR}/*.yaml
fi

# Run web3signer binary
# - Run key manager (it may change in the future): --key-manager-api-enabled=true
exec /opt/web3signer/bin/web3signer \
  --key-store-path="$KEYFILES_DIR" \
  --http-listen-port=9000 \
  --http-listen-host=0.0.0.0 \
  --http-host-allowlist="web3signer.web3signer-prater.dappnode,brain.web3signer-prater.dappnode,$ETH2_CLIENT_DNS" \
  --http-cors-origins="http://web3signer.web3signer-prater.dappnode,http://brain.web3signer-prater.dappnode,http://$ETH2_CLIENT_DNS" \
  --metrics-enabled=true \
  --metrics-host 0.0.0.0 \
  --metrics-port 9091 \
  --metrics-host-allowlist="*" \
  --idle-connection-timeout-seconds=900 \
  eth2 \
  --network=$NETWORK \
  --slashing-protection-db-url=jdbc:postgresql://postgres.web3signer-prater.dappnode:5432/web3signer \
  --slashing-protection-db-username=postgres \
  --slashing-protection-db-password=password \
  --slashing-protection-pruning-enabled=true \
  --slashing-protection-pruning-epochs-to-keep=500 \
  --key-manager-api-enabled=true \
  ${EXTRA_OPTS}
