import { LightningElement } from 'lwc';

export default class GoogleMap extends LightningElement {

    renderedCallback() {
        var script = document.createElement('script');
        script.src = 'https://maps.googleapis.com/maps/api/js?key=AIzaSyB41DRUbKWJHPxaFjMAwdrzWzbVKartNGg&amp;callback=initMap&amp;libraries=&amp;v=weekly';
        script.type = 'text/javascript';
        this.template.appendChild(script);

        var script1 = document.createElement('script');
        script1.src = 'https://polyfill.io/v3/polyfill.min.js?features=default';
        script1.type = 'text/javascript';
        this.template.appendChild(script1);
    }

    initMap() {
        let map;
        map = new google.maps.Map( this.template.querySelector('[data-id="map"]' ), {
          center: { lat: -34.397, lng: 150.644 },
          zoom: 15,        
        });
    }
}