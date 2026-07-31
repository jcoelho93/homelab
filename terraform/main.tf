terraform {
  required_version = ">= 1.15.8"
  required_providers {
    desec = {
        source = "Valodim/desec"
        version = "0.6.1"
    }
  }
  backend "s3" {
    bucket = "terraform"
    key = "homelab/terraform.tfstate"
    region = "auto"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    skip_requesting_account_id = true
    skip_s3_checksum = true
    use_path_style = true
    endpoints = {
        s3 = "https://80f1f7aa87321620830c03e7f59e07bc.r2.cloudflarestorage.com"
    }
  }
}

provider "desec" {}

resource "desec_domain" "jlab" {
  name = "jlab.dedyn.io"
}

locals {
    records = [
        {
            name = "cloudbeaver"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "api.cartaz"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "cartaz"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "headness"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "transmission"
            type = "A"
            records = ["192.168.1.240"]
        },
        {
            name = "jellyfin"
            type = "A"
            records = ["192.168.1.240"]
        },
        {
            name = "pi"
            type = "A"
            records = ["192.168.1.240"]
        },
        {
            name = "auth"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "api.clearbook"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "grafana"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "clearbook"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "prospero"
            type = "A"
            records = ["91.99.216.255"]
        },
        {
            name = "api.prospero"
            type = "A"
            records = ["91.99.216.255"]
        }
    ]
}

resource "desec_rrset" "jlab" {
    for_each = { for r in local.records : "${r.name}-${r.type}" => r }

    domain = desec_domain.jlab.name
    subname = each.value.name
    type = each.value.type
    records = each.value.records
    ttl = 3600
}

import {
    id = "jlab.dedyn.io/cloudbeaver/A"
    to = desec_rrset.jlab["cloudbeaver-A"]
}

import {
    id = "jlab.dedyn.io/api.cartaz/A"
    to = desec_rrset.jlab["api.cartaz-A"]
}

import {
    id = "jlab.dedyn.io/cartaz/A"
    to = desec_rrset.jlab["cartaz-A"]
}

import {
    id = "jlab.dedyn.io/headness/A"
    to = desec_rrset.jlab["headness-A"]
}

import {
    id = "jlab.dedyn.io/transmission/A"
    to = desec_rrset.jlab["transmission-A"]
}

import {
    id = "jlab.dedyn.io/jellyfin/A"
    to = desec_rrset.jlab["jellyfin-A"]
}

import {
    id = "jlab.dedyn.io/pi/A"
    to = desec_rrset.jlab["pi-A"]
}

import {
    id = "jlab.dedyn.io/auth/A"
    to = desec_rrset.jlab["auth-A"]
}

import {
    id = "jlab.dedyn.io/api.clearbook/A"
    to = desec_rrset.jlab["api.clearbook-A"]
}

import {
    id = "jlab.dedyn.io/grafana/A"
    to = desec_rrset.jlab["grafana-A"]
}

import {
    id = "jlab.dedyn.io/clearbook/A"
    to = desec_rrset.jlab["clearbook-A"]
}

import {
    to = desec_domain.jlab
    id = "jlab.dedyn.io"
}
