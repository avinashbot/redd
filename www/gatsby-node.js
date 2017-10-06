const path = require('path')

exports.createPages = ({ graphql, boundActionCreators }) => {
  const { createPage } = boundActionCreators

  return new Promise((resolve, reject) => {
    const GuidePageTemplate = path.resolve('./src/templates/guide-page.js')
    resolve(
      graphql(`
        {
          allFile(filter: { relativePath: { regex: "/.*\\\\.md/" } }) {
            edges {
              node {
                relativePath
                childMarkdownRemark {
                  id
                }
              }
            }
          }
        }
      `).then((result) => {
        if (result.errors) {
          reject(result.errors)
        }

        // Create blog posts pages.
        result.data.allFile.edges.forEach((edge) => {
          const relativePath = '/' + edge.node.relativePath.slice(0, -3)
          createPage({
            path: relativePath,
            component: GuidePageTemplate,
            context: { id: edge.node.childMarkdownRemark.id }
          })
        })
      })
    )
  })
}
