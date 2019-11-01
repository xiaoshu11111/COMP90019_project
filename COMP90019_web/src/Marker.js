import React from 'react';
import Icon from "@material-ui/core/Icon";

// this class shows the star icon on the map, when the mouse hover over the icon, the size and colour will change
class Marker extends React.Component {
  componentDidMount() {

  }

  render() {
    // store the size and changed size
    const style = this.props.$hover ? {fontSize: 22} : {fontSize: 18};
    // store the colour and changed colour
    const color_set = this.props.$hover ? "primary" : "secondary";
    return (
      <div>
        <Icon
          color= {color_set}
          style= {style}
        >
          star
        </Icon>
      </div>
    );
  }
}

export default Marker;
