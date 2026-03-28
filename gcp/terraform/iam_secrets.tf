resource google_secret_manager_secret empath_secret {
    secret_id = empath-dev-api-key
    replication {
        user_managed {
            replicas {
                location = us-central1
            }
        }
    }
}

resource google_project_iam_binding dev_viewer {
    project = var.project_id
    role    = roles/viewer
    members = [
        user:admin@empathome.com,
    ] 
}