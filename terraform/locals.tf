locals {
    common_tags = merge(
        var.tags,
        { project = "empath" }
    )
}