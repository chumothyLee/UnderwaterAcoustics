import React from 'react'
import DocumentTitle from 'react-document-title'
import { config } from 'config'

exports.data = {
  title: 'Fish Calls',
}

const SomeReactCode = React.createClass({

  render () {
    const page = this.props.route.page

    return (
      <DocumentTitle title={`${page.data.title} | ${config.siteTitle}`}>
        <div>
          <h1>Fish Calls</h1>
            <p>
              Some examples of the recorded fish calls are shown below. The acoustic data for these species of fish along with others was manually classified by researchers.
              Our team seeks to use this information to continue the development of a Convolutional Neural Network that can take in acoustic samples and tell us which species
              produced them. 
            </p>
            <table border="0">
              <tbody>
                <tr>
                  <td><img src="./CroakFish.jpeg" width="500"></img></td>
                  <td><audio controls>
                      Your browser does not support the <code>audio</code> element.
                      <source src="./Croak.wav" type="audio/wav"></source>
                    </audio></td>
                </tr>
                <tr>
                  <td><img src="./JetSkiFish.jpeg" width="500"></img></td>
                  <td><audio controls>
                      Your browser does not support the <code>audio</code> element.
                      <source src="./Jet-Ski.wav" type="audio/wav"></source>
                    </audio></td>
                </tr>
              </tbody>
            </table>
            <h1>Our CNN as of now</h1>
            <p>
              Below is a sample output of our CNN. While it produces satisfactory results, we hope to improve its accuracy and usability moving forward.
            </p>
            <img src="./ClassifierResults.png"></img>
        </div>
      </DocumentTitle>
    )
  },
})

export default SomeReactCode
