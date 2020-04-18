provider "aws" {
  version = "~> 2.0"
  region  = var.vpc_region 
}

module "network" {
    source                  =  "./network"

    name                    = format("%s-%s-%s-%s", var.prefix, var.region_name, var.stage, var.service)
    azs                     = var.azs
    public_subnets          = var.public_subnets
    private_subnets         = var.private_subnets
    tags                    = var.tags
    vpc_cidr                = var.vpc_cidr
    vpc_region              = var.vpc_region
}

module "pdb" {
    source          = "./prometheus"

    vpc_id          = module.network.vpc_id
    public_subnet   = module.network.public_subnets
    private_subnet  = module.network.private_subnets
    tags            = var.tags
}