#!/bin/bash

export ARM_ACCESS_KEY=$(az keyvault secret show --name tfstatestorageaccountkey --vault-name storageaccountkey0627 --query value -o tsv)