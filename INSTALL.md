
```
gcloud builds submit --tag gcr.io/heidless-pfolio-deploy-5/blog_demo_0 .

```

[Fix Rails Blocked Host Error with Docker](https://danielabaron.me/blog/rails-blocked-host-docker-fix/)

[production ready rails/docker - docker-rails-example](https://github.com/nickjj/docker-rails-example)

# [Running Rails on Google Cloud](https://cloud.google.com/ruby/rails)
## - [Running Rails on the Cloud Run environment ](https://cloud.google.com/ruby/rails/run)
## - [Quickstart: Deploy a Ruby service to Cloud Run](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/deploy-ruby-service)

###################################################

## [Running Rails on the Cloud Run environment ](https://cloud.google.com/ruby/rails/run)

### Cloning the Rails app
```
git clone https://github.com/GoogleCloudPlatform/ruby-docs-samples.git

cd ruby-docs-samples/run/rails
bundle install
```

### create SQL instance
### [instances](https://console.cloud.google.com/sql/instances?project=heidless-pfolio-deploy-5)

# USEFUL IF NEEDED
```
# enable/diable deletion protection
gcloud sql instances patch blog-demo-db-1 \
    --deletion-protection

gcloud sql instances patch blog-demo-instance-2 \
    --no-deletion-protection

```

```
gcloud sql instances delete blog-demo-instance-2 \
--project=heidless-pfolio-deploy-5

```

## prep OS
```
cd ./run/rails
npx update-browserslist-db@latest
sudo apt install apt-utils
```

```
gcloud sql instances create blog-demo-instance-3 \
    --database-version POSTGRES_12 \
    --tier db-f1-micro \
    --region europe-west2
---
blog-demo-instance-1
havana11
```

### Create a database
### [Create a database](https://console.cloud.google.com/sql/instances/blog-demo-instance-1/databases?project=heidless-pfolio-deploy-5)

```
gcloud sql databases create blog-demo-db-3 \
    --instance blog-demo-instance-3
---
blog-demo-db-2
```

### Create a user
### [create user](https://console.cloud.google.com/sql/instances/blog-demo-instance-1/users?project=heidless-pfolio-deploy-5)

```
# generate password to 'dbpassword'.
# in PRODUCTION USE 'dbpassword'. 
cat /dev/urandom | LC_ALL=C tr -dc '[:alpha:]'| fold -w 50 | head -n1 > dbpassword
---
gcloud sql users create blog-demo-user-1 \
   --instance=blog-demo-instance-3 --password=$(cat dbpassword)
---

```
### Set up a Cloud Storage bucket
### [storage bucket](https://console.cloud.google.com/storage/browser?referrer=search&project=heidless-pfolio-deploy-5&prefix=&forceOnBucketsSortingFiltering=true)

```
gsutil mb -l europe-west2 gs://heidless-pfolio-deploy-5-blog-demo-bucket-3

```

### [bucket permissions]()
```
gsutil iam ch allUsers:objectViewer gs://heidless-pfolio-deploy-5-blog-demo-bucket-3
```

## Secret Mgr
### Create encrypted credentials file and store key as Secret Manager secret
```
# install sublime
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt-get update

# ubuntu window
sudo apt-get install sublime-text
EDITOR='subl --wait' bin/rails credentials:edit

#bin/rails credentials:edit
---
encryption key:
ee76a92fbd84ff47d31c8cdc05cf0902
---

# edit credentials in config/credentials.yml.enc
config/credentials.yml.enc
---
secret_key_base: GENERATED_VALUE
gcp:
  db_password: RshvlXzpfRsLnqOYjbyIlqukndVIAlbdkTGMRyeBPGbXSlYtUf
---
```

```
gcloud secrets create blog-demo-secret-2 --data-file config/master.key

gcloud secrets describe blog-demo-secret-2

gcloud secrets versions access latest --secret blog-demo-secret-2
---
fafd6fd66c0232abbb9948614d3c2682%
---

```

```
gcloud projects describe heidless-pfolio-deploy-5 --format='value(projectNumber)'
---
110223146514
---
```

```
gcloud secrets add-iam-policy-binding blog-demo-secret-3 \
    --member serviceAccount:110223146514-compute@developer.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

---

gcloud secrets add-iam-policy-binding blog-demo-secret-3 \
    --member serviceAccount:110223146514@cloudbuild.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor
```

## Connect Rails app to production database and storage
### .env
```
cd PROJECT_ROOT
touch .env
---
PRODUCTION_DB_NAME: blog-demo-db-3
PRODUCTION_DB_USERNAME: blog-demo-user-1
CLOUD_SQL_CONNECTION_NAME: heidless-pfolio-deploy-5:europe-west2:blog-demo-instance-3
GOOGLE_PROJECT_ID: heidless-pfolio-deploy-5
STORAGE_BUCKET_NAME: heidless-pfolio-deploy-5-blog-demo-bucket-3
```

## Grant Cloud Build access to Cloud SQL
```
gcloud projects add-iam-policy-binding heidless-pfolio-deploy-5 \
    --member serviceAccount:110223146514@cloudbuild.gserviceaccount.com \
    --role roles/cloudsql.client
```

# Deploying the app to Cloud Run

```
gcloud builds submit --config cloudbuild.yaml \
    --substitutions _SERVICE_NAME=blog-demo-svc-2,_INSTANCE_NAME=blog-demo-instance-3,_REGION=europe-west2,_SECRET_NAME=blog-demo-secret-3
---

gcloud run deploy blog-demo-svc-2 \
     --platform managed \
     --region europe-west2 \
     --image gcr.io/heidless-pfolio-deploy-5/blog-demo-svc-2 \
     --add-cloudsql-instances heidless-pfolio-deploy-5:europe-west2:blog-demo-instance-3 \
     --allow-unauthenticated
---



```

