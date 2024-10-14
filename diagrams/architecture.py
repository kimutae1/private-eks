from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS, EKS, Lambda
from diagrams.aws.security import SecretsManager
from diagrams.aws.management import Cloudwatch
from diagrams.aws.integration import MQ , SQS
from diagrams.aws.network import Route53, ALB
from diagrams.aws.storage import S3
from diagrams.aws.database import RDS, RDSInstance, AuroraInstance, Aurora, Elasticache, Dynamodb
from diagrams.k8s.clusterconfig import HPA
from diagrams.k8s.compute import Deployment, Pod, ReplicaSet
from diagrams.k8s.network import Ingress, Service


with Diagram("private-eks_dorian_Architecture",show=False, direction="LR"):  # 전체 다이어그램 방향 설정
    with Cluster("[Route53]"): 
        r53 = Route53("Route54"),
    with Cluster("[ELB]"): 
     alb = ALB("ALB")
    with Cluster("[AWS EKS]", direction="LR"): 
      Ing = Ingress("Ingress") 
      Svc = Service("Service")
      Ing >> Svc 
      with Cluster("Cluster[private-eks]", direction="LR"):  # 클러스터 방향을 Left to Right으로 설정
          with Cluster("node1[microservices]"):
              dep1 = Deployment("Deployment")  
              workers = [Pod("worker1"),
                         Pod("worker2")]
              kubelet1 = Pod("kubelet")

          with Cluster("node2[microservices]"):
              dep2 = Deployment("Deployment")  
              workers2 = [Pod("worker1"),
                          Pod("worker2")]
              kubelet2 = Pod("kubelet")
      Svc >> workers
      r53 >> alb >> Ing


      with Cluster("Cluster[ArgoCD]", direction="LR"):  # 클러스터 방향을 Left to Right으로 설정
          with Cluster("node[argo]"):
              argoserver = Pod("ArgoServer")
      argoserver >> dep1 
      dep1 - dep2



    with Cluster("[AWS ECS]"): 
      with Cluster("Cluster[portal]", direction="LR"): 
         with Cluster("fronend", direction="LR"):
            ssoweb=ECS("sso-web")
            ssoweb-ECS("adm-web")-ECS("portal-web")
         with Cluster("backend"):
            papi=ECS("portal-api")
            ECS("adm-api")-ECS("earth-api") - papi
                    #ECS("portal-api")

    with Cluster("[MessageQue]"): 
        SQS("SQS")
        mq = MQ("MQ1")
    with Cluster("[DataBase]"): 
      Elasticache("Elasticache")
      with Cluster("RDS Cluster[portal]"): 
        prds= RDS("[Portal]")
        prds >> AuroraInstance("portal")

      with Cluster("RDS Cluster[private-eks]"): 
        ards= RDS("alertnow")
        ards0= RDSInstance("alertnow0")

      ards >> ards0
    
    papi >> prds
    workers2 >> ards

    with Cluster("[OnDemand]"):
        S3("S3")
        clw = Cloudwatch("Cloudwatch")
        SecretsManager("SecretsManager")
    workers2 >> mq
    workers2 >> clw
    papi >> clw


    alb >> ssoweb
    


#        with Cluster("EKS1"):
#    with Cluster("luke"):
#       aa = [
#            Pod("luke-configuration-synchronizer"),
#            Pod("luke-refinement-alert"),
#            Pod("luke-refinement-collector"),
#            Pod("luke-refinement-configuration"),
#            Pod("luke-refinement-configuration-r2dbc"),
#            Pod("luke-interface-grpc"),
#            Pod("luke-refinement-transmogrifier"),
#            Pod("luke-common")]
#
#    with Cluster("light-saber"):
#       bb = [
#            Pod("ls-incident-svc"),
#            Pod("ls-mobileapi"),
#            Pod("ls-openapi"),
#            Pod("ls-postman-svc"),
#            Pod("ls-sync-batch"),
#            Pod("ls-webapps"),
#            Pod("ls-wechat-svc")]
#
#
#    with Cluster("etc"):
#       [Pod("alertnow-webapp-v2"),
#        Pod("alertnow-notification-landing"),
#        Pod("spring-common-ext"),
#        Pod("spring-mybatis-ext"),
#        Pod("spring-web-ext")]

  #  luke >> light-saber

