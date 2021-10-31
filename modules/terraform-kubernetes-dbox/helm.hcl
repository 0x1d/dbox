locals {
  helm = {
    repos = [
      { hashicorp = https://helm.releases.hashicorp.com },
      { cocainefarm = https://kube.cat/chartrepo/cocainefarm },
      { k8s-at-home = https://k8s-at-home.com/charts/ }
    ]
    install = [
      {
        name = waypoint
        chart = hashicorp/waypoint
      },
      {
        name = nginx-rtmp 
        chart = cocainefarm/nginx-rtmp 
        version = 0.7.0
      }
    ]
  }
}