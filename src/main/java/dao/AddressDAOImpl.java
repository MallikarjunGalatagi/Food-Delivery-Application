package dao;

import model.Address;
import util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDAOImpl implements AddressDAO {

    @Override
    public List<Address> getAddressesByCustomerId(int customerId) {
        List<Address> list = new ArrayList<>();
        String sql = "SELECT * FROM addresses WHERE customer_id = ? ORDER BY is_default DESC, id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapAddress(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Address getAddressById(int addressId) {
        String sql = "SELECT * FROM addresses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAddress(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean addAddress(Address address) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // If it is set to default, reset others first
            if (address.isDefault()) {
                resetDefaultAddresses(conn, address.getCustomerId());
            } else {
                // If it is the first address, make it default automatically
                String checkSql = "SELECT COUNT(*) FROM addresses WHERE customer_id = ?";
                try (PreparedStatement psCheck = conn.prepareStatement(checkSql)) {
                    psCheck.setInt(1, address.getCustomerId());
                    try (ResultSet rs = psCheck.executeQuery()) {
                        if (rs.next() && rs.getInt(1) == 0) {
                            address.setDefault(true);
                        }
                    }
                }
            }

            String sql = "INSERT INTO addresses (customer_id, address_line1, address_line2, city, state, postal_code, is_default) VALUES (?, ?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, address.getCustomerId());
                ps.setString(2, address.getAddressLine1());
                ps.setString(3, address.getAddressLine2());
                ps.setString(4, address.getCity());
                ps.setString(5, address.getState());
                ps.setString(6, address.getPostalCode());
                ps.setBoolean(7, address.isDefault());
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    @Override
    public boolean updateAddress(Address address) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            if (address.isDefault()) {
                resetDefaultAddresses(conn, address.getCustomerId());
            }

            String sql = "UPDATE addresses SET address_line1 = ?, address_line2 = ?, city = ?, state = ?, postal_code = ?, is_default = ? WHERE id = ? AND customer_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, address.getAddressLine1());
                ps.setString(2, address.getAddressLine2());
                ps.setString(3, address.getCity());
                ps.setString(4, address.getState());
                ps.setString(5, address.getPostalCode());
                ps.setBoolean(6, address.isDefault());
                ps.setInt(7, address.getId());
                ps.setInt(8, address.getCustomerId());
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    @Override
    public boolean deleteAddress(int addressId) {
        String sql = "DELETE FROM addresses WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addressId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public boolean setDefaultAddress(int customerId, int addressId) {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            resetDefaultAddresses(conn, customerId);

            String sql = "UPDATE addresses SET is_default = 1 WHERE id = ? AND customer_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, addressId);
                ps.setInt(2, customerId);
                ps.executeUpdate();
            }

            conn.commit();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        return false;
    }

    private void resetDefaultAddresses(Connection conn, int customerId) throws SQLException {
        String sql = "UPDATE addresses SET is_default = 0 WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        }
    }

    private Address mapAddress(ResultSet rs) throws SQLException {
        return new Address(
            rs.getInt("id"),
            rs.getInt("customer_id"),
            rs.getString("address_line1"),
            rs.getString("address_line2"),
            rs.getString("city"),
            rs.getString("state"),
            rs.getString("postal_code"),
            rs.getBoolean("is_default")
        );
    }
}
