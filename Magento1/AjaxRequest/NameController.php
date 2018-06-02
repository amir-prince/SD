<?php

/**
 * @autor @mir
 * @object booking controller
 * Class Module_Name_ReservationController
 */
class Module_Name_NameController extends Mage_Core_Controller_Front_Action
{

    public function indexAction() {
        $this->loadLayout();
        $this->renderLayout();
    }

    /**
     * @object add product dynamically with his option and extra_options retrieved from AJAX request
     * @autor @mir
     */
    public function addAction() {
        //Retrieving submitting data
        $activity = $this->getRequest()->getPost('activity');
        $activityName = $this->getRequest()->getPost('activityname');
        $option_id = $this->getRequest()->getPost('option_id');
        $option_value = $this->getRequest()->getPost('option_value');
        $date = $this->getRequest()->getPost('date');
        $person = $this->getRequest()->getPost('person');
        $duration = $this->getRequest()->getPost('duration');
        $hour = $this->getRequest()->getPost('hour');

        if( isset($activity) && isset($option_id) && isset($option_value) && !empty($date) && isset($person) && isset($hour) ) {
            $product = Mage::getSingleton('catalog/product')->load($activity);
            $options = array($option_id => $option_value);
            $additional_data = array();
            $additional_data['option1'] = ['label' => 'Date', 'value' => $date,];
            $additional_data['option2'] = ['label' => 'Personnes', 'value' => $person,];
            //$additional_data['option3'] = ['label' => 'Durée', 'value' => $duration,];// deja dans $options
            $additional_data['option4'] = ['label' => 'Heure', 'value' => $hour,];


            $params = array(
                'product' => $activity,
                'qty' => 1,
                'options' => $options
            );

            try {
                $cart = Mage::getSingleton('checkout/cart');
                $product->addCustomOption('additional_options', serialize($additional_data));
                $cart->addProduct($product, $params);
                $cart->save();
                Mage::getSingleton('checkout/session')->setCartWasUpdated(true);
                $response = "200";
                $this->getResponse()->clearHeaders()->setHeader('Content-type','application/json',true);
                $this->getResponse()->setBody(Mage::helper('core')->jsonEncode($response));
                Mage::getSingleton('core/session')->addSuccess('Votre session' . '&nbsp;' . $activityName . ' a été créée avec succès !');
            } catch (Exception $e) {
                Mage::logException($e);
                $response = "500";
                $this->getResponse()->clearHeaders()->setHeader('Content-type','application/json',true);
                $this->getResponse()->setBody(Mage::helper('core')->jsonEncode($response));
            }
        }else {
            $response = "300";
            $this->getResponse()->clearHeaders()->setHeader('Content-type','application/json',true);
            $this->getResponse()->setBody(Mage::helper('core')->jsonEncode($response));
            Mage::log('The Values posted from the reservation form were not all filled, see Reservationcontroller.php/addAction ');
        }
    }
}

