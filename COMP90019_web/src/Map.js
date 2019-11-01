import React, { Component } from 'react';
import GoogleMapReact from 'google-map-react';
import { Tooltip, withStyles } from '@material-ui/core'
import HelpIcon from '@material-ui/icons/Help';
import firebase, { dbRef, images } from "./firebase";
import { withRouter } from 'react-router-dom';
import './App.css';
import Marker from "./Marker";
import WholeMarker from "./WholeMarker";
import Typography from "@material-ui/core/Typography";

// set the style of tooltip for user instruction and save the style setting in const HtmlTooltip
const HtmlTooltip = withStyles(theme => ({
  tooltip: {
    backgroundColor: '#f5f5f9',
    color: 'rgba(0, 0, 0, 0.87)',
    maxWidth: 220,
    fontSize: theme.typography.pxToRem(12),
    border: '1px solid #dadde9',
  },
}))(Tooltip);

class SimpleMap extends Component {

  // set the default center and zoom level of the map when the home page is loaded
  static defaultProps = {
    center: {
      lat: -37.811,
      lng: 144.963,
    },
    zoom: 15
  };

  // set state arguments
  constructor(props) {
    super(props);
    this.state = {
      graffiti: [],
      hoverKey: "",
      clickKey: "",
      whole: null,
    };
  }

// call this function after the first rendering, set state and render again
// recommended by React official
  componentDidMount() {
    dbRef.on("value", (snapshot) => {
      const keys = Object.keys(snapshot.val());
      this.setState({
        // if "graffiti" == "false" and "dislike" > 10, then this graffiti will be hidden
        // otherwise, get the key, latitude and longitude
        graffiti: keys.map(key => ({
          key,
          ...snapshot.val()[key],
        })).filter(item => (!(item.graffiti && (item.dislike || 0) > 10))).map(item => ({
          lat: parseFloat(item.location.split(" ")[0]),
          lng: parseFloat(item.location.split(" ")[1]),
          ...item,
        })),
      });
    }, function (errorObject) {
      console.log("The read failed: " + errorObject.code);
    });
  }

  // listen, when clicks on the icon
  _onChildClick = (key, childProps) => {
    console.log(key);
    const id = this.state.graffiti[childProps.data.key];
    console.log(childProps);
    this.setState({
      whole: childProps.data,
    });
  };

  // listen, when mouse enters the icon
  _onChildMouseEnter = (key) => {
    this.setState({
      hoverKey: key,
    });

  };

  // listen, when mouse leaves the icon
  _onChildMouseLeave = ( key) => {
    this.setState({
      hoverKey: key,
    });
  };

  render() {
    console.log(this.state);
    // store values to show the whole marker on the map, if not clicks on the icon, this const will be null
    // otherwise, stores the data of this icon, see function: _onChildClick
    const whole = this.state.whole;
    // store values to show star icon on the map
    const Marks =
      this.state.graffiti.map(item => item.lat ? (
          <Marker lat={item.lat} lng={item.lng} data={item} key={item.key} />
        ) : null);

    return (
      <div style={{ height: '90vh', width: '100%' }}>
        <div style={{
          backgroundColor: '#505FB5',
          color: 'white',
          margin: 0,
          display: 'flex',
          flexDirection: 'row',
          justifyContent: 'space-between',
        }}>
          <div style={{display: 'flex', flexDirection: 'row', justifyContent: 'center', alignItems: 'center'}}>
            <p style={{fontSize: 25, marginLeft: 30, fontWeight: 700, marginRight: 10, marginTop: 12, marginBottom: 12}}>Home</p>
            <HtmlTooltip
              placement="right"
              style={{borderRadius: 7}}
              title={
                <React.Fragment>
                  <Typography color="inherit" style={{marginTop: 5, marginBottom: 5, fontStyle: 'italic', fontSize:11}}>
                    - Each star icon represents a graffiti posted by users <br />
                    - Click on the star icon to see details <br />
                    - Click on the comment icon to view more and add comments <br />
                    - If you think it is good graffiti, click on like. Otherwise, click on dislike <br />
                    - If more than 10 users dislike the post and it is not a graffiti (which is decided by our analysis),
                    then the post will be hidden <br />
                    Now, start enjoying the fun of graffiti and sharing!</Typography>
                </React.Fragment>
              }
            ><HelpIcon style={{opacity:0.65, fontSize: 20, marginTop: 5}}/>
            </HtmlTooltip>
          </div>
          <p style={{ fontSize: 25, fontStyle: 'italic', marginRight: 20, marginTop: 12, marginBottom: 12, fontWeight: 700 }}>Graffiti</p>
        </div>
        <GoogleMapReact
          bootstrapURLKeys={{ key: "AIzaSyCouHD0WK3bi-Wu2qm1pKs8uPTF0cB-6Iw"}}
          onClick={({ x, y, lat, lng, event } ) => {
            this.setState({
              whole: null,
            });
          }}
          defaultCenter={this.props.center}
          defaultZoom={this.props.zoom}
          onChildClick={this._onChildClick}
          onChildMouseEnter={this._onChildMouseEnter}
          onChildMouseLeave={this._onChildMouseLeave}
          hoverDistance={30}
        >
          {Marks}
          {whole && <WholeMarker lng={whole.lng} lat={whole.lat} data={whole} key="whole" />}
        </GoogleMapReact>
      </div>
    );
  }
}

export default withRouter(SimpleMap);
