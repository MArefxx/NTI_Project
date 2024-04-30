pipeline{

  agent any

  stages{
    stage('Fitch last code updates'){
      steps{
        git(url: 'https://github.com/MArefxx/NTI_Project.git', branch: 'main')

      }
    }


    stage('building the Image'){
      steps{
        sh "docker build -t simpledjangoapp-docker-master_web:${env.BUILD_NUMBER} SimpleDjangoApp-Docker-master/."                    
        withCredentials([string(credentialsId: 'my-ecr', variable: 'LOGIN')]) {   
                 sh "pip3 install --upgrade awscli"
                 sh "$LOGIN"
                 sh "docker tag simpledjangoapp-docker-master_web:${env.BUILD_NUMBER} public.ecr.aws/o6x2k0k2/public_ecr:${env.BUILD_NUMBER}"
                 sh "docker push public.ecr.aws/o6x2k0k2/public_ecr:${env.BUILD_NUMBER}" 
                }

      }
    }

    stage('update k8s files'){
      steps{
        sh "sed -i 's|image:.*|image: public.ecr.aws/k9h2m6v6/radioshash-repo:${env.BUILD_NUMBER}|g\' k8s/django/deployment.yml"
      }
    }



    stage('Deploy'){
      steps{
              withCredentials([file(credentialsId:'k8s', variable:'KUBECONFIG')]){
                script{
              sh "kubectl  --kubeconfig=$KUBECONFIG apply -f k8s/django/deployment.yml"
              sh "kubectl  --kubeconfig=$KUBECONFIG apply -fk8s/django/service.yml"
              sh "kubectl  --kubeconfig=$KUBECONFIG apply -f k8s/db/deploy.yml"
              sh "kubectl  --kubeconfig=$KUBECONFIG apply -fk8s/db/service.yml"
              sh "kubectl  --kubeconfig=$KUBECONFIG apply -fk8s/db/network-policy.yml"
            }
         }
              
      }
    }



  }
}
