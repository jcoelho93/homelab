create-k3s:
	hetzner-k3s create --config homelab.yaml

diff:
	helmfile diff

apply:
	helmfile apply

encrypt:
	sops --encrypt secrets/grafana.yaml > secrets/grafana.enc.yaml
