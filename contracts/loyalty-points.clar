;; Loyalty Points Contract
;; A minimal fungible token contract for awarding and redeeming loyalty points

;; Define the loyalty points token
(define-fungible-token loyalty-points)

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-amount (err u101))
(define-constant err-insufficient-balance (err u102))

;; Track total supply
(define-data-var total-supply uint u0)


(define-public (award-points (recipient principal) (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (asserts! (> amount u0) err-invalid-amount)
    (try! (ft-mint? loyalty-points amount recipient))
    (var-set total-supply (+ (var-get total-supply) amount))
    (ok true)))


(define-public (redeem-points (customer principal) (amount uint))
  (begin
    (asserts! (> amount u0) err-invalid-amount)
    (asserts! (>= (ft-get-balance loyalty-points customer) amount) err-insufficient-balance)
    (try! (ft-burn? loyalty-points amount customer))
    (var-set total-supply (- (var-get total-supply) amount))
    (ok true)))
