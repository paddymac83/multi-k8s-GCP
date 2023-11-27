docker build -t paddymac83/multic-client:latest -t paddymac83/multic-client:$SHA -f ./client/Dockerfile ./client  # build images from Dockerfiles
docker build -t paddymac83/multic-server:latest -t paddymac83/multic-server:$SHA -f ./server/Dockerfile ./server
docker build -t paddymac83/multic-worker:latest -t paddymac83/multic-worker:$SHA -f ./worker/Dockerfile ./worker
# travis already logged us into Docker so can push the tagged built images
# SHA Allows us t tage with latest git commit sha, so that the deployment update picks up the latest image
docker push paddymac83/multic-client:$SHA
docker push paddymac83/multic-server:$SHA
docker push paddymac83/multic-worker:$SHA

docker push paddymac83/multic-client:latest
docker push paddymac83/multic-server:latest
docker push paddymac83/multic-worker:latest
# travis has configured the kubectl CLI so we can just then apply all the configs
kubectl apply -f k8s
# update newly built images to our defined deployments
kubectl set image deployments/server-deployment server=paddymac83/multi-server:$SHA
kubectl set image deployments/client-deployment client=paddymac83/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=paddymac83/multi-worker:$SHA