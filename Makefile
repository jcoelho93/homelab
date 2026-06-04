create-k3s:
	hetzner-k3s create --config homelab.yaml

diff:
	helmfile diff

apply:
	helmfile apply

encrypt:
	sops --encrypt secrets/grafana.yaml > secrets/grafana.enc.yaml

grafana-password:
	@kubectl get secret --namespace default grafana-admin-credentials -o jsonpath="{.data.GF_SECURITY_ADMIN_PASSWORD}" | base64 --decode | xclip -selection clipboard
