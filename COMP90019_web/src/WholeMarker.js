import React from 'react';
import { Icon } from "@material-ui/core";
import firebase from "./firebase";
import { withRouter } from 'react-router-dom';
import global from "./global";

class WholeMarker extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      image: '',
      like: 0,
      dislike: 0,
    };
    this.haslike = false;
    this.hasdislike = false;
  }

  addLike = () => {
    const like = this.props.data.like || 0;
    const id = this.props.data.key;
    if (!global[id].haslike) {
      this.setState({
        like: this.state.like + 1,
      });
      global[id].haslike = true;
      firebase.database().ref('images/' + id).update({
        like: like + 1,
      });
    }
  };

  addDisLike = () => {
    const dislike = this.props.data.dislike || 0;
    const id = this.props.data.key;
    if (!global[id].haslike) {
      this.setState({
        dislike: this.state.dislike + 1,
      });
      global[id].haslike = true;
      firebase.database().ref('images/' + id).update({
        dislike: dislike + 1,
      });
    }
  };

  componentDidMount() {
    const id = this.props.data.key;
    firebase.storage().ref(`images/${id}.jpg`).getDownloadURL().then(url => {
      console.log(url);
      this.setState({
        image: url,
      });
    }).catch(e => console.log(e));
    const like = this.props.data.like || 0;
    const dislike = this.props.data.dislike || 0;
    this.setState({
      like,
      dislike,
    });
    if (!global[id]) {
      global[id] = {
        haslike: false,
        hasdislike: false,
      }
    }
  }

  render() {
    const data = this.props.data;
    const color_set = this.props.$hover ? "secondary" : "default" ;
    return (
      <div style={{
        width: 250,
        // height: 70,
        padding:5,
        display: 'flex',
        flexDirection: 'row',
        backgroundColor: 'white',
        borderRadius: 7
        }}>
        {this.state.image && <img src={this.state.image} alt="img"
                                  style={{ width: 50, height: 50, margin: 8}} />}
        <div style={{ flex: 1, display: 'flex', flexDirection: 'column' }}>
          <p style={{ margin: 3 }}>{data.description}</p>
          <p style={{ margin: 3 }}>{data.tag}</p>
          <div style={{ marginTop: 'auto', flexDirection: 'row', display: 'flex',  justifyContent: 'center', alignItems: 'center' }}>
            <Icon onClick={() => {
              this.props.history.push(`${data.key}/comments`);
            }}
                  style={{ color: '#333', margin: 3, fontSize: 20 }}
            >
              comment
            </Icon>
            <div style={{ marginLeft: 'auto', flexDirection: 'row', display: 'flex', justifyContent: 'center', alignItems: 'center', }}>
              <Icon
                color={color_set}
                style={{margin: 5, fontSize: 20 }}
                onClick={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  this.addLike();
                }}
              >thumb_up</Icon>
              <span>{this.state.like}</span>
              <Icon
                color={color_set}
                style={{margin: 5, fontSize: 20 }}
                onClick={(e) => {
                  e.preventDefault();
                  e.stopPropagation();
                  this.addDisLike();
                }}
              >thumb_down</Icon>
              <span>{this.state.dislike}</span>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default withRouter(WholeMarker);
