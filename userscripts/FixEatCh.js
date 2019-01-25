// ==UserScript==
// @name         No More Sponsored Eat.ch
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       You
// @match        https://www.eat.ch/restaurants/8117?*so=min-order
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    // remove recommendations
    var xpath = "//h2[contains(text(),'Empfehlungen ')]";
    var matchingElement = document.evaluate(xpath, document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue;
    if (matchingElement) {
        matchingElement.parentNode.removeChild(matchingElement);
    }
    let recs = document.querySelector('.restaurants-list-wrapper');
    if (recs) {
        recs.parentNode.removeChild(recs);
    }

    let sponsorContainer = document.querySelector('ul.restaurants-list');
    let sponsoreds = sponsorContainer.querySelectorAll(':scope > li');
    sponsorContainer.parentNode.removeChild(sponsorContainer);

    let normalContainer = document.querySelector('ul.restaurants-list');
    sponsoreds.forEach(li => {
        const label = li.querySelector(':scope .restaurant__sponsored-label');
        label.parentNode.removeChild(label);
        normalContainer.appendChild(li);
    });

    let allRestaurants = Array.from(normalContainer.querySelectorAll(':scope li.restaurant-item')).map(rest => {
        const minOrder = rest.querySelector(':scope span.restaurant-block__delivery-cost--minimum-order');
        return {
            rest,
            cost: minOrder && +minOrder.innerText.split('CHF')[1] || 0
        }
    }).sort((a, b) => a.cost > b.cost);
    allRestaurants.forEach(r => r.rest.parentNode.removeChild(r.rest));
    allRestaurants.forEach(r => normalContainer.appendChild(r.rest));
})();
