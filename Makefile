create-k3s:
	hetzner-k3s create --config homelab.yaml

apply:
	helmfile apply

encrypt:
	sops --encrypt --in-place charts/cal-diy/secrets.yaml

decrypt:
	sops charts/cal-diy/secrets.yaml
