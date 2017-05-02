import React from 'react'
import Demo from './_Demo'
import DocumentTitle from 'react-document-title'
import { config } from 'config'

exports.data = {
  title: 'Who We Are',
}

const SomeReactCode = React.createClass({

  render () {
    const page = this.props.route.page

    return (
      <DocumentTitle title={`${page.data.title} | ${config.siteTitle}`}>
        <div>
          <h1>Our Team</h1>

            <table border="0">
              <tbody>
                <tr> <td> </td> <td> </td> </tr>
                <tr>
                  <td> <h3>Jeremy </h3>  </td>
                  <td> </td>
                </tr>
                <tr> 
                  <td width="30%" align="center"> <img src={'jeremy.jpg'} alt="jeremy" className="img-responsive" width={200} /> </td>
                  <td width="70%">
                    <p>
                        I am a third year undergraduate at UCSD majoring in Computer Science.  I am interested in continuing my education in graduate school, where I hope to specialize in Artificial Intelligence and its applications with robotics.  I’m very passionate about cat videos, and hope to one day command a capital ship in Star Citizen.
                    </p> 
                  </td>
                </tr>

                <tr>
                  <td> <h3>Rochelle </h3>  </td>
                  <td> </td>
                </tr>
                <tr> 
                  <td width="30%" align="center"> <img src={'scary.jpg'} alt="rochelle" className="img-responsive" width={200} height={270} /> </td>
                  <td width="70%">
                    <p>
                       I'm a 3rd year Computer Science major with a minor in Environmental Studies; I want to apply my knowledge in Computer Science to real world applications, specifically in finding methods to better the health of our environment. Fun fact about me is that I spend lots of time watching YouTube videos and spend hours listening to indie/alternative music.
                    </p> 
                  </td>
                </tr>

                <tr>
                  <td> <h3>Luis </h3>  </td>
                  <td> </td>
                </tr>
                <tr> 
                  <td width="30%" align="center"> <img src={'sexy.jpg'} alt="luis" className="img-responsive" width={200} /> </td>
                  <td width="70%">
                    <p>
                        I am a third year Computer Science major at UCSD.  I have experience working with iOS and mobile app development.  When I'm not programming, I like to go to the gym to work out and stay strong, watch workout videos, and I enjoy cooking.  
                    </p> 
                  </td>
                </tr>

                <tr>
                  <td> <h3>Tiffany </h3>  </td>
                  <td> </td>
                </tr>
                <tr> 
                  <td width="30%" align="center"> <img src={'cutie.jpg'} alt="tiffany" className="img-responsive" width={200} /> </td>
                  <td width="70%">
                    <p>
                      I am currently a third year Computer Science major at UCSD.  I am interested in front-end development and object-oriented design. In my free time, I enjoy swimming, going to the beach, eating, and watching my favorite shows.
                    </p> 
                  </td>
                </tr>
                
              </tbody>
            </table>
              
          <div
            style={{
              height: 500,
            }}
          >
            
          </div>
        </div>
      </DocumentTitle>
    )
  },
})

export default SomeReactCode
