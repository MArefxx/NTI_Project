pipeline{

  agent any

  stages{
    stage('Fitch last code updates'){
      steps{
        git(url: '', branch: 'main')

      }
    }


    stage('build Image'){
      steps{
        sh "docker build -t radioshash-repo:${env.BUILD_NUMBER} App_Sourcecode/."                    
        withCredentials([string(credentialsId: 'ecr', variable: 'LOGIN')]) {   
                 sh "$LOGIN"
                 sh "docker tag radioshash-repo:${env.BUILD_NUMBER} public.ecr.aws/k9h2m6v6/radioshash-repo:${env.BUILD_NUMBER}"
                 sh "docker push public.ecr.aws/k9h2m6v6/radioshash-repo:${env.BUILD_NUMBER}" 
                }

      }
    }

    stage('update k8s files'){
      steps{
        sh "sed -i 's|image:.*|image: public.ecr.aws/k9h2m6v6/radioshash-repo:${env.BUILD_NUMBER}|g\' Kubernetes/deployment.yml"
      }
    }



    stage('Deploy'){
      steps{
         withCredentials([file(credentialsId:'k8s', variable:'KUBECONFIG')]){
                script{
                    sh "kubectl --kubeconfig=$KUBECONFIG apply -f Kubernetes/deployment.yml"
                    sh "kubectl --kubeconfig=$KUBECONFIG apply -f Kubernetes/service.yml"
                    sh "kubectl --kubeconfig=$KUBECONFIG apply -f Kubernetes/network-policy.yml"
                }
         }
      }
    }



  }
}
