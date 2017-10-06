import React from 'react'
import Link from 'gatsby-link'
import SimplePage from '../components/SimplePage'

const NotFound = () => (
  <SimplePage>
    <h1>Four Zero Four</h1>
    <p>Looks like you hit a non-existent or removed page. Sorry about that.</p>
    <p><Link to='/'>Go Back?</Link></p>
  </SimplePage>
)

export default NotFound
