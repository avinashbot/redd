import React from 'react'
import Helmet from 'react-helmet'
import Link from 'gatsby-link'
import { Icon } from 'semantic-ui-react'
import SimplePage from '../components/SimplePage'

const GuidePageTemplate = ({ data }) => {
  console.log(data)
  const post = data.markdownRemark
  const siteTitle = data.site.siteMetadata.title

  return (
    <SimplePage>
      <Helmet title={`${post.frontmatter.title} - ${siteTitle}`} />
      <h1>
        <Link to='/'><Icon name='home' /></Link>
        &#47; {post.frontmatter.title}
      </h1>
      <div dangerouslySetInnerHTML={{ __html: post.html }} />
    </SimplePage>
  )
}

export default GuidePageTemplate

export const pageQuery = graphql`
  query GuidePageByPath($id: String!) {
    site {
      siteMetadata {
        title
      }
    }
    markdownRemark(id: { eq: $id }) {
      html
      frontmatter {
        title
      }
    }
  }
`
