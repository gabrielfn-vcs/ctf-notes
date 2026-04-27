# TODO List

## Enhancements for Preview Workflow (`mkdocs-preview.yml`)

- [ ] Add comment to the PR with the preview URL, so there is no need to click into Actions.

### Implementation Details
Use the official action `actions/github-script`, which allows execution of a small JS snippet to comment on the PR.
- Add the right permission to post comments.
- Post a comment on the PR with the preview URL.
- If the comment already exists, then update it instead of spamming.
- Always shows the latest deployment link.

1. Add `pull-requests: write` permission.
  ```yaml
  permissions:
    contents: read
    pages: write
    id-token: write
    pull-requests: write
  ```
2. Add script logic to `mkdocs-preview.yml` after the deploy step in the deploy job.
    ```yaml
    jobs:
      [...]
      deploy:
        [...]
        steps:
          - name: Deploy Preview Site Artifact to GitHub Pages
            id: deploy
            uses: actions/deploy-pages@v4

          - name: Comment Preview URL on PR
            uses: actions/github-script@v7
            with:
              script: |
              const url = "${{ steps.deploy.outputs.page_url }}";

              const body = `## 🔍 MkDocs Preview URL
              
              ${url}

              _This preview updates automatically when new commits are pushed to this PR._`;

              const { data: comments } = await github.rest.issues.listComments({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: context.issue.number,
              });

              const botComment = comments.find(comment =>
                comment.user.type === "Bot" &&
                comment.body.includes("MkDocs Preview")
              );

              if (botComment) {
                await github.rest.issues.updateComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                comment_id: botComment.id,
                body: body,
                });
              } else {
                await github.rest.issues.createComment({
                owner: context.repo.owner,
                repo: context.repo.repo,
                issue_number: context.issue.number,
                body: body,
                });
              }
    ```