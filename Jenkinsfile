pipeline {
    agent {
        kubernetes {
            // You might want to specify a label that's unique to this job to avoid conflicts.
            label 'my-k8s-agent'
            yaml '''
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:debug
      command:
      - cat
      tty: true
      volumeMounts:
      - name: shared-data
        mountPath: /shared
    - name: wizcli
      image: wiziocli.azurecr.io/wizcli:latest
      command:
      - cat
      tty: true
      volumeMounts:
      - name: shared-data
        mountPath: /shared
  volumes:
  - name: shared-data
    emptyDir: {}
'''
        }
    }

    environment {
        WIZ_POLICY = 'imsed-cicd-policy'
        WIZ_CLIENT_ID = credentials('WIZ_CLIENT_ID')
        WIZ_CLIENT_SECRET = credentials('WIZ_CLIENT_SECRET')
    }

    stages {
        stage('Kaniko Build') {
            steps {
                container('kaniko') {
                    sh '''
                    mkdir -p /kaniko/.docker
                    echo '{}' > /kaniko/.docker/config.json
                    /kaniko/executor --context . --dockerfile Dockerfile --destination=dummy --no-push --tarPath /shared/my-image.tar
                    '''
                }
            }
        }
        
        stage('Scan Image with Wiz-CLI') {
            steps {
                container('wizcli') {
                    sh '''
                    /entrypoint auth --id $WIZ_CLIENT_ID --secret $WIZ_CLIENT_SECRET 
                    /entrypoint docker scan -p $WIZ_POLICY --image /shared/my-image.tar
                    '''
                }
            }
        }
    }
}
