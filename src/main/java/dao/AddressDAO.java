package dao;

import model.Address;
import java.util.List;

public interface AddressDAO {
    List<Address> getAddressesByCustomerId(int customerId);
    Address getAddressById(int addressId);
    boolean addAddress(Address address);
    boolean updateAddress(Address address);
    boolean deleteAddress(int addressId);
    boolean setDefaultAddress(int customerId, int addressId);
}
