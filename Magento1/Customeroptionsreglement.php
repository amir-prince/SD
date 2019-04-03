<?php
class Vendor_Module_Model_Eav_Entity_Attribute_Source_Customeroptionsreglement extends Mage_Eav_Model_Entity_Attribute_Source_Abstract
{
    /**
     * @object Retrieve all active payment methods options array Per Customer
     * @autor @mir
     * @return array
     */
    public function getAllOptions()
    {
        if (is_null($this->_options)) {
            $customerId = Mage::registry('current_customer')->getId();
            $customerWebsiteId = Mage::registry('current_customer')->getWebsiteId();
            $allActivePaymentMethods = Mage::getModel('payment/config')->getActiveMethods($customerWebsiteId);
            $collection = new Varien_Data_Collection();
            foreach($allActivePaymentMethods as $row){
                $dataPaiement = array('id'=>$row->getId(),
                              'title'=>$row->getTitle(),
                              'code'=>$row->getCode(),
                              'store'=>$row->getStore()
                );
                $rowObj = new Varien_Object();
                $rowObj->setData($dataPaiement);
                $collection->addItem($rowObj);
            }

            //now you can get the data using collection way
            foreach($collection as $_data){
                $paymentMethods[$_data->getCode()] = array(
                    'label' => $_data->getTitle(),
                    'value' => $_data->getCode(),
                );

            }
            return $paymentMethods;
        }

    }

}
